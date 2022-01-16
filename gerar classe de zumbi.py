import tkinter as tk

name:str
texture:str
hframes:int
vframes:int
damage:list
speed:int

app = tk.Tk()
app.geometry('300x300')

entry_name = tk.Entry()
entry_name.insert(0, 'name')

entry_texture = tk.Entry()
entry_texture.insert(0, 'texture')

entry_hframes = tk.Entry()
entry_vframes = tk.Entry()
entry_damage = tk.Entry()
entry_speed = tk.Entry()

entry_name.grid(column=1, row=0)
entry_texture.grid(column=2, row=0)

app.mainloop()
