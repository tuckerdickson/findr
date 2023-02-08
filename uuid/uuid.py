import uuid

def generateUUIDs(num):
    for i in range(num):
        x = uuid.uuid4()
        print(x)

