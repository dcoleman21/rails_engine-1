# As a developer, I would like to make a rake task such as "rake seed:csv" which populates my database with
# the CSV data in a reproducable way.
#
# This Rake Task should:
# - Clear your Development database to prevent data duplication
# - Seed your Development database with the CSV data
# - Be invokable through Rake, i.e. you should be able to run `bundle exec rake <your_rake_task_name>` from
# the command line
# - Convert all prices before storing. Prices are in cents, therefore you will need to transform them to
# dollars. (`12345` becomes `123.45`)
# - Reset the primary key sequence for each table you import so that new records will receive the next valid
# primary key.

# lib/tasks/seeds_from_csv.rake
require "csv"

namespace :csv_import do
  desc "Seed csv data from db/csv_files to database table"

  task cleardata: :environment do
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    puts("Records destroyed")
  end

  task resetkey: :environment do
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  task seedCSV: :environment do
    def read_csv(resource)
      file = "db/csv_files/#{resource}.csv"
      CSV.read(file, headers: true, header_converters: :symbol)
    end

    read_csv("items").each do |line|
      Item.create!( id: line[:id],
                    name: line[:name],
                    description: libe[:description],
                    price: line[:unit_price],
                    merchant: line[:merchant_id],
                    created_at: line[:created_at],
                    updated_at: line[:updated_at])
    end
    puts("Item: File imported")

    read_csv("merchants").each do |line|
      binding.pry
      Merchant.create!( id: line[:id],
                        name: line[:name],
                        created_at: line[:created_at],
                        updated_at: line[:updated_at])
    end
    puts("Merchant: File imported")

    read_csv("customers").each do |line|
      Customer.create!( id: line[:id],
                        first_name: line[:first_name],
                        last_name: line[:last_name],
                        created_at: line[:created_at],
                        updated_at: line[:updated_at])
    end
    puts("Customer: File imported")

    read_csv("transactions").each do |line|
      Transaction.create!(  id: line[:id],
                            invoice: line[:invoice_id],
                            card: line[:credit_card_number],
                            card_exp: line[:credit_card_expiration_date],
                            status: line[:result],
                            created_at: line[:created_at],
                            updated_at: line[:updated_at])
    end
    puts("Transaction: File imported")

    read_csv("invoices").each do |line|
      Invoice.create!(  id: line[:id],
                        customer: line[:customer_id],
                        merchant: line[:merchant_id],
                        status: line[:status],
                        created_at: line[:created_at],
                        updated_at: line[:updated_at])
    end
    puts("Invoice: File imported")

    read_csv("invoice_items").each do |line|
      InvoiceItem.create!(  id: line[:id],
                            item: line[:item_id],
                            invoice: line[:invoice_id],
                            quantity: line[:quantity],
                            unit_price: line[:unit_price],
                            created_at: line[:created_at],
                            updated_at: line[:updated_at])
    end
    puts("InvoiceItem: File imported")
  end
end
