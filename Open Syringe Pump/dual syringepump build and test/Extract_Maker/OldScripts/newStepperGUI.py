import piplates.MOTORplate as MOTOR 
import time
import os
import string
from Tkinter import *
import tkFont
        
class headerBLOCK:
    def __init__(self,master,r,c):
        self.master=master
        self.tit=Frame(self.master,padx=4,pady=4,bd=2,bg='white',relief='sunken')
        self.tit.grid(row=r,column=c, columnspan=2,sticky=N+S+W+E)    
         
        ##Create Fonts
        self.title = tkFont.Font(family='Helvetica', size=32, weight='bold') 
        self.heading = tkFont.Font(family='Helvetica', size=18, weight='bold')           
                
        self.close_button = Button(self.tit, text="X", command=root.quit).grid(sticky=N+E)  
        
        self.labelt = Label(self.tit, text="DeRisi Lab Extract Maker", bg='white',fg='#000666000',padx=4,pady=4,font=self.title,anchor="center")
        self.labelt.grid(sticky=W+E) 
        #self.pp.bind("<ButtonRelease-1>", self.shutdown)
        
        def shutdown(self,event):
            print "clicked at", event.x, event.y
        
        
class stepperGUI:
    def __init__(self,master,title,stepper,r,c):
        self.stepState=0       #stopped
        smColor="yellow"
        slwidth=20
        slength=120
        self.mVal=stepper
        self.master=master
        self.sm=Frame(self.master,padx=4,pady=4,bd=2,relief='sunken')
        self.sm.grid(row=r,column=c, rowspan=3, sticky=N+S+W+E)
        
        ##Create Fonts
        self.title = tkFont.Font(family='Helvetica', size=18, weight='bold') 
        self.heading = tkFont.Font(family='Helvetica', size=12, weight='bold')
        
        ##Title
        self.labelt = Label(self.sm, text=title, padx=4,pady=4, bg=smColor, fg='black',font=self.title)
        self.labelt.grid(row=0,column=0,columnspan=2,sticky=W+E)
 
        ##Direction Control
        self.labeld = Label(self.sm, text="Direction",padx=4,pady=4,font=self.heading)
        self.labeld.grid(row=1,column=1,sticky=W)       
        self.direction = IntVar()
        self.direction.set(0)
        self.cwb = Radiobutton(self.sm, text='Clockwise', variable=self.direction, value=0)
        self.ccwb = Radiobutton(self.sm, text=' Counter Clockwise', variable=self.direction, value=1)
        self.direction.set(0)
        self.cwb.grid(row=2,column=1,sticky=W)
        self.ccwb.grid(row=3,column=1,sticky=W)


        ##Step Count Control
        self.labelstep = Label(self.sm, text="Step Count",padx=4,pady=4,font=self.heading)
        self.labelstep.grid(row=9,column=0)
        self.steps=IntVar()
        self.steps.set(0)
        self.StepSet=Scale(self.sm,variable=self.steps,from_=2000,to=0,width=slwidth,length=slength)
        self.StepSet.grid(row=10,column=0,rowspan=1)                

        ##Jog Button
        self.startButton=Button(self.sm,text="JOG",fg="black",bg="green",height=3, width=6,command=self.jog)
        self.startButton.grid(row=10,column=1)
 
        ##Move Button
        self.startButton=Button(self.sm,text="MOVE",fg="white",bg="blue",height=3, width=6,command=self.move)
        self.startButton.grid(row=10,column=2) 
        
        ##Stop Button
        self.stopButton=Button(self.sm,text="STOP",fg="white",bg="red",height=3, width=6,command=self.stop)
        self.stopButton.grid(row=11,column=1)  

        ##Off Button
        self.stopButton=Button(self.sm,text="OFF",fg="black",bg="yellow",height=3, width=6,command=self.off)
        self.stopButton.grid(row=11,column=2) 
        
        self.stop()   #ensure motor is off at start
        self.off()   #ensure motor is off at start
 
        
    def ratedelta(self,val):
        if (self.stepState==1):
            MOTOR.stepperRATE(0,self.mVal,self.rate.get())

    def jog(self):
        if (self.direction.get() == 0):
            dir='cw'
        else:
            dir='ccw'
        MOTOR.stepperCONFIG( 0,self.mVal,dir,self.ss.get(),self.rate.get(),self.acc.get())
        MOTOR.stepperJOG(0,self.mVal)
        self.stepState=1
        
    def move(self):
        if (self.direction.get() == 0):
            dir='cw'
        else:
            dir='ccw'
        MOTOR.stepperCONFIG(0,self.mValo,dir,self.ss.get(),self.rate.get(),self.acc.get())
        MOTOR.stepperMOVE(0,self.mVal,self.steps.get())
        self.stepState=2
        
    def stop(self):
        MOTOR.stepperSTOP(0,self.mVal)    
        self.stepState=0            

    def off(self):
        MOTOR.stepperOFF(0,self.mVal)    
        self.stepState=0     
        

MOTOR.RESET(0)
MOTOR.RESET(1)    
        
root = Tk()
root.config(bg="black")
root.attributes("-fullscreen", TRUE)
swidth=root.winfo_screenwidth()
sheight=root.winfo_screenheight()
#print tkFont.families()
container=Frame(root,bg="white")
container.place(relx=0.5, rely=0.5, anchor=CENTER)

title = headerBLOCK(container,0,1)
ma_gui = stepperGUI(container,"Stepper Motor A",'a',1,1)
mb_gui = stepperGUI(container,"Stepper Motor B",'b',1,2)


root.mainloop()