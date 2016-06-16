# add_roles runs this under rails runner

TO_ADD = ['smartproxy']
TO_REMOVE = []

def sort_roles(str)
  str.split(',').sort.join(',')
end

puts "default: #{sort_roles(Vmdb::Settings.template_settings.server.role)}"
puts "current: #{sort_roles(Settings.server.role)}"

new_role = ((Settings.server.role.split(',') | TO_ADD) - TO_REMOVE).sort.join(',')
Vmdb::Settings.save!(MiqServer.my_server(true), {server: {role: new_role}})
Vmdb::Settings.reload!

puts "    now: #{sort_roles(Settings.server.role)}"
