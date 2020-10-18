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
require 'csv'

namespace :csv_import do
  desc 'Seed csv data from db/csv_files to database table'

  task seedCSV: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute
    puts('Records destroyed')

    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end

    def read_csv(resource)
      file = "db/csv_files/#{resource}.csv"
      CSV.read(file, headers: true, header_converters: :symbol)
    end

    read_csv('merchants').each do |line|
      Merchant.create!(id: line[:id],
                       name: line[:name],
                       created_at: line[:created_at],
                       updated_at: line[:updated_at])
    end
    puts('Merchant: File imported')

    read_csv('customers').each do |line|
      Customer.create!(id: line[:id],
                       first_name: line[:first_name],
                       last_name: line[:last_name],
                       created_at: line[:created_at],
                       updated_at: line[:updated_at])
    end
    puts('Customer: File imported')

    read_csv('items').each do |line|
      Item.create!(id: line[:id],
                   name: line[:name],
                   description: line[:description],
                   unit_price: (line[:unit_price].to_f / 100).round(2),
                   merchant: Merchant.find(line[:merchant_id].to_i),
                   created_at: line[:created_at],
                   updated_at: line[:updated_at])
    end
    puts('Item: File imported')

    read_csv('invoices').each do |line|
      Invoice.create!(id: line[:id],
                      customer: Customer.find(line[:customer_id].to_i),
                      merchant: Merchant.find(line[:merchant_id].to_i),
                      status: line[:status],
                      created_at: line[:created_at],
                      updated_at: line[:updated_at])
    end
    puts('Invoice: File imported')

    read_csv('invoice_items').each do |line|
      InvoiceItem.create!(id: line[:id],
                          item: Item.find(line[:item_id].to_i),
                          invoice: Invoice.find(line[:invoice_id].to_i),
                          quantity: line[:quantity],
                          unit_price: (line[:unit_price].to_f / 100).round(2),
                          created_at: line[:created_at],
                          updated_at: line[:updated_at])
    end
    puts('InvoiceItem: File imported')


    read_csv('transactions').each do |line|
      Transaction.create!(id: line[:id],
                          invoice: Invoice.find(line[:invoice_id].to_i),
                          card: line[:credit_card_number].to_i,
                          result: line[:result],
                          created_at: line[:created_at],
                          updated_at: line[:updated_at])
    end
    puts('Transaction: File imported')
  end
end
