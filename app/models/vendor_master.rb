class VendorMaster < ApplicationRecord

    def self.fetch_customer_details(customer_name)
        customer_info = find_by(customer_name: customer_name)
        {
          customer_code: customer_info.customer_code,
          corporate_number: customer_info.corporate_number,
          invoice_number: customer_info.invoice_number
        }
      end
end
