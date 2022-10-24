# This is a sample Python script.

# Press ⇧F10 to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import json
import csv
import matplotlib.pyplot as plt

def readcsv():
    lastline = ""
    with open("./CallCenter.csv", 'r') as file:

        csvreader = csv.reader(file)
        for row in csvreader:
            lastline = row
    return analyze_satisfaction(lastline)
def analyze_satisfaction(line):
    item_no = 0
    normal_s_list = []
    vip_s_list = []
    line = list(line)

    for item in line:

        if (item_no % 2) == 0 and item_no != 0:
            vip_s_list.append(item)
        elif (item_no % 2) != 0 and item_no != 0:
            normal_s_list.append(item)
        item_no += 1

    num_normal = len(normal_s_list)
    num_vip = len(vip_s_list)

    formated_vip_s_list = []
    formated_normal_s_list = []



    for i in range(num_vip):
        correct_string = vip_s_list[i].replace(" ", ", ")

        correct_list = json.loads(correct_string)
        formated_vip_s_list.append(correct_list)

    for i in range(num_normal):
        correct_string = normal_s_list[i].replace(" ", ", ")

        correct_list = json.loads(correct_string)
        formated_normal_s_list.append(correct_list)

    return [formated_normal_s_list,formated_vip_s_list]

def counting(list):
    normal= len(list)
    first_satisfaction = 0   # <30
    second_satisfaction = 0  # 30 - 60
    third_satisfaction = 0   # 60 -90
    forth_satisfaction = 0  # >90


    for iteration in list:
        for item in iteration:
            if item < 30:
                first_satisfaction += 1
            elif item >= 30 and item < 60:
                second_satisfaction += 1
            elif item >= 60 and item < 90:
                third_satisfaction += 1
            elif item >= 90:
                forth_satisfaction += 1



    return [first_satisfaction, second_satisfaction, third_satisfaction, forth_satisfaction]


def make_bar_chart(list,type):
    xAxis = ["<30","30 - 60", "60 -90", ">90"]
    yAxis = counting(list)
    plt.bar(xAxis,yAxis)
    plt.title(type+" client satisfaction distribution when staff is 3")
    plt.xlabel('Satisfaction degree')
    plt.ylabel('The number of clients')
    plt.show()













# Press the green button in the gutter to run the script.
if __name__ == '__main__':
   formated_normal, formated_vip = readcsv()
   make_bar_chart(formated_normal,"normal")
   make_bar_chart(formated_vip,"vip")


# See PyCharm help at https://www.jetbrains.com/help/pycharm/
