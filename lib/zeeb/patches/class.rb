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

    def after_inherited child = nil, &blk
    line_class = nil
    set_trace_func(lambda do |event, file, line, id, binding, classname|
      unless line_class
        # save the line of the inherited class entry
        line_class = line if event == 'class'
      else
        # check the end of inherited class
        if line == line_class && event == 'end'
          # if so, turn off the trace and call the block
          set_trace_func nil
          blk.call child
        end
      end
    end)
  end

end