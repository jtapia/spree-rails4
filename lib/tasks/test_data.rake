namespace :populate do
  desc 'populate test data'
  task test_data: :environment do
    # Populate shipping and billing address
    country = Spree::Country.find_by(iso: 'US')
    state = country.states.select{ |state| state.name == 'California' }.first
    address = Spree::Address.create(
      firstname: 'User',
      lastname: 'Test',
      address1: '123 Fake St.',
      city: 'San Francisco',
      zipcode: '94110',
      state_name: state.name,
      country_id: country.id,
      state_id: state.id,
      phone: '41598765'
    )

    # Populate users
    2.times do |i|
      Spree::User.create(
        email: "user#{i}@test.com",
        password: 'spree123',
        password_confirmation: 'spree123',
        created_at: Date.today - 1.days
      )
    end

    # Populate orders
    total = Random.rand(10...50)
    10.times do
      Spree::Order.new(
        item_total: total,
        state: 'complete',
        user_id: Spree::User.all.sample.id,
        created_at: Date.today - 1.days,
        ship_address_id: address.id,
        bill_address_id: address.id,
        payment_total: total,
        item_count: 1,
        shipment_total: 10.00,
        shipment_state: 'shipped',
        payment_state: 'paid',
        email: Spree::User.all.sample.email,
        shipping_method_id: 1
      )
    end
  end
end