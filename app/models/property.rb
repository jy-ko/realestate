class Property < ApplicationRecord
    belongs_to :account


    def filterrific(
        default_filter_params: { sorted_by: 'created_at_desc' },
        available_filters: [
          :sorted_by,
          :search_query,
          :with_country_id,
          :with_created_at_gte
        ]
      )
    end

    # sorted by scope 

    # scope :with_address, ->(addresses) {
    #     where(address: [*addresses])
    #   }
    scope :sorted_by, ->(sort_option) {
        # extract the sort direction from the param value.
        direction = /desc$/.match?(sort_option) ? "desc" : "asc"
        case sort_option.to_s
        when /^created_at_/
          # Simple sort on the created_at column.
          # Make sure to include the table name to avoid ambiguous column names.
          # Joining on other tables is quite common in Filterrific, and almost
          # every ActiveRecord table has a 'created_at' column.
          order("students.created_at #{direction}")
        when /^name_/
          # Simple sort on the name colums
          order("LOWER(students.last_name) #{direction}, LOWER(students.first_name) #{direction}")
        when /^country_name_/
          # This sorts by a student's country name, so we need to include
          # the country. We can't use JOIN since not all students might have
          # a country.
          order("LOWER(countries.name) #{direction}").includes(:country).references(:country)
        else
          raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
        end
      }
    scope :search_query, ->(query) {
        # Searches the students table on the 'first_name' and 'last_name' columns.
        # Matches using LIKE, automatically appends '%' to each term.
        # LIKE is case INsensitive with MySQL, however it is case
        # sensitive with PostGreSQL. To make it work in both worlds,
        # we downcase everything.
        return nil  if query.blank?
      
        # condition query, parse into individual keywords
        terms = query.downcase.split(/\s+/)
      
        # replace "*" with "%" for wildcard searches,
        # append '%', remove duplicate '%'s
        terms = terms.map { |e|
          (e.tr("*", "%") + "%").gsub(/%+/, "%")
        }
        # configure number of OR conditions for provision
        # of interpolation arguments. Adjust this if you
        # change the number of OR conditions.
        num_or_conds = 2
        where(
          terms.map { |_term|
            "(LOWER(students.first_name) LIKE ? OR LOWER(students.last_name) LIKE ?)"
          }.join(" AND "),
          *terms.map { |e| [e] * num_or_conds }.flatten,
        )
      }
end
