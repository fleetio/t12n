# frozen_string_literal: true

RSpec.describe "examples" do
  it "full" do
    t12n = T12n.start

    users = [
      Ivo.(
        id: 1,
        first_name: "John",
        last_name: "Smith",
        email: "js@example.com",
        work_company: Ivo.(
          id: 10,
          name: "Productco",
          city: "Boston",
          state: "MA",
          year: 1950,
        ),
      ),
      Ivo.(
        id: 2,
        first_name: "Jane",
        last_name: "Doe",
        email: "jd@example.com",
        work_company: Ivo.(
          id: 20,
          name: "Serviceco",
          city: "Atlanta",
          state: "GA",
          year: 1985,
        ),
      ),
    ]

    t12n.define_schema :user do
      attrs :id

      # define_attr :name do |user|
      #   "#{user.first_name} #{user.last_name}"
      # end

      define_attr :name do |user|
        "#{user.first_name} #{user.last_name}"
      end

      associated_attrs :company, [:name, :location, :year] do |user|
        user.work_company
      end

      with_context do |context|
        attrs *context[:extra_user_attrs]
      end
    end

    t12n.define_schema :company do
      attrs :id, :name

      define_attr :location do |company|
        "#{company.city}, #{company.state}"
      end

      with_context do |context|
        attrs *context[:extra_company_attrs]
      end
    end

    schema = t12n.fetch_schema(
      :user,
      extra_user_attrs: [:email],
      extra_company_attrs: [:year]
    )

    result = [schema.attrs.map(&:name)]

    users.each do |user|
      result << schema.attrs.map do |attr|
        attr.serializer.(user)
      end
    end

    expect(result).to eq(
      [
        %w[id name company.name company.location company.year email],
        [1, "John Smith", "Productco", "Boston, MA", 1950, "js@example.com"],
        [2, "Jane Doe", "Serviceco", "Atlanta, GA", 1985, "jd@example.com"],
      ]
    )
  end
end
