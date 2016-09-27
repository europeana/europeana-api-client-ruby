module Europeana
  module API
    class Record
      class Hierarchy
        ##
        # Retrieve record preceding siblings hierarchy data over the Europeana API
        class PrecedingSiblings < Base
          def api_method
            'preceeding-siblings' # mis-spelt on the API
          end
        end
      end
    end
  end
end