f = open("C:\\Users\Jack Sparrow\Input\Tesla.txt","r");
message = f.read()
list1 = message.split(".")
#Splitting can be implemented as required
print(list1)
f2 = open("C:\\Users\Jack Sparrow\\Kia.txt","w")
for i in list1:
    f2.write(i)
    f2.write("\n")
f2.close()