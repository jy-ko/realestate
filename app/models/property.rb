class Property < ApplicationRecord
    belongs_to :account

    scope :sorted_by, ->(sort_option) {
      direction = /desc$/.match?(sort_option) ? "desc" : "asc"
      case sort_option.to_s
      when /^name/
        order("LOWER(properties.name) #{direction}")
      when /^country/
        order("LOWER(properties.country) #{direction}")
      when /^created_at/
        order("properties.created_at #{direction}")
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
          "(LOWER(properties.name) LIKE ?)"
        }.join(" AND "),
        *terms.map { |e| [e] * num_or_conds }.flatten,
      )
    }
    filterrific(
      default_filter_params: { sorted_by: "created_at" },
      available_filters: [
        :sorted_by,
        :search_query
      ]
    )
    def self.options_for_sorted_by
      [
        ['Name', 'name_asc'],
        ['Country', 'country_asc'],
        ['Created at (newer first)', 'created_at_desc'],
        ['Created at (older first)', 'created_at_asc'],
      ]
    end
end
