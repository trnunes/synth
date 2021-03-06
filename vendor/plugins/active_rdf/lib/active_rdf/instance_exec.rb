module Kernel
 # Like instace_eval but allows parameters to be passed.
  def instance_exec(*args, &block)
    mname = "__instance_exec_#{Thread.current.object_id.abs}_#{object_id.abs}"
    Object.class_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      puts mname
      Object.class_eval{ undef_method(mname) } rescue nil
    end
    ret
  end
end
