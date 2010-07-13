sys: require 'sys'
child_process: require 'child_process'

# For now, this just shells out to a ruby script.
# In the future, this should probably have bindings to libid3?

exports.getTags: (file, callback) ->
  child: child_process.exec "bin/id3.rb '$file'", (err, stdout, stderr) ->
    if err
      #sys.debug sys.inspect(err)
      #sys.debug stderr
      callback { error: true }
    else
      callback JSON.parse(stdout)

