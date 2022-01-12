
object = {"a": {"b": {"c": "d" }}}
val = input("Enter your key value: in the formate of x/y/z ")

def new_function(val):
    object = {"a": {"b": {"c": "d" }}}
    a = val.split("/")
    for i in a:
        for key, value in object.items():
            if key == i:                                 # checks if key is valid or not
                object = value
                w =value
            else:
                w = "key not found"
                break                                    
    print(w)                                             # prints the value 
new_function(val)                                        # function call

"""

Below step explains the login

Step 1: reads the user provided value during the run time

Step 2: calls the new_function

Step 3: Split the user input into array of keys

Step 4: function

        for each value in array
        {
            for each key value in object
            {
                if(key is present)
                {
                    object = value
                }
                else 
                {
                    print(key not found)
                    break
                }

            }
        }
Step 5 : function call 

"""
