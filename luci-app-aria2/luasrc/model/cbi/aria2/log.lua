local f = SimpleForm("aria2")
f.reset = false
f.submit = false
f:append(Template("aria2/log_template"))

return f
