import json
file = "result.txt"

dict = {}

with open(file) as fn:
    for d in fn:
        key , desc = d.strip().split("=",1)
        dict[key] = desc.strip()
otfile = open("output2.json", "w")
json.dump(dict,otfile)
otfile.close()
