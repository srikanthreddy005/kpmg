

object = {"a": {"b": {"c": "d" }}}
val = input("Enter your key value: in the formate of x/y/z ")
#input = "a/b/d"
a = val.split("/")
#print(a)
#d=object.keys()
#v=object.values()
for i in a:
    for key, value  in object.items():
        if key == i:
            object= value
            w = value
        else:
            w = "key not found"
            break
print(w)
