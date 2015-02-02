require 'inline'
class Class
    inline do |builder|

        builder.c %{            
            VALUE set_super(VALUE sup) {
                RCLASS(self)->super = sup;
                return sup;
            }
        }

        builder.c %{
            VALUE get_super() {
                return RCLASS(self)->super;
            }
        }

    end
end