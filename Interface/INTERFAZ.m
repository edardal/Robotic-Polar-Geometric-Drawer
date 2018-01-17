
function varargout = INTERFAZ(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @INTERFAZ_OpeningFcn, ...
                   'gui_OutputFcn',  @INTERFAZ_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT



function INTERFAZ_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for INTERFAZ
handles.output = hObject;

assignin('base','abierto',0);

assignin('base','pol',0);
assignin('base','nlados',3);
assignin('base','radio',5);
set(handles.uipanel1,'Title','Interfaz')

n=evalin('base','nlados');
set(handles.text5, 'String', num2str(n));

r=evalin('base','radio');
set(handles.text6, 'String', num2str(r));

set(handles.text7, 'String', 'circunferencia');

axes(handles.axes4)
xlim([0 20])
ylim([0 20])
grid 

axes(handles.axes1)
xlim([0 15])
ylim([0 15])
grid 


% Update handles structure
guidata(hObject, handles);

function varargout = INTERFAZ_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---RESET
function pushbutton2_Callback(hObject, eventdata, handles)

disp('RESET')
set_param('SIMU_ROBOT','SimulationCommand','stop')


axes(handles.axes1)
cla
axes(handles.axes4)
cla

clear all




        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%------Nº LADOS
function edit1_Callback(hObject, eventdata, handles)

assignin('base','nlados',str2double(get(hObject,'String')));
n=evalin('base','nlados');
set(handles.text5, 'String', num2str(n));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--- ON/OFF
function radiobutton1_Callback(hObject, eventdata, handles)
get(hObject,'Value')

if get(hObject,'Value')==1
    respuesta='ON'
end
if get(hObject,'Value')==0
    respuesta='OFF'
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---RADIO
function edit2_Callback(hObject, eventdata, handles)

assignin('base','radio',str2double(get(hObject,'String')));
r=evalin('base','radio');
set(handles.text6, 'String', num2str(r));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit3_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_ButtonDownFcn(hObject, eventdata, handles)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---POL/CIR
function pushbutton4_Callback(hObject, eventdata, handles)

poli=evalin('base','pol');
disp('POL/CIR')
if poli==1
    respuesta='circunferencia'
    set(handles.text7, 'String', respuesta);
    assignin('base','pol',0);
end
if poli==0
    respuesta='poligono'
    set(handles.text7, 'String', respuesta);
    assignin('base','pol',1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---RUN
function pushbutton5_Callback(hObject, eventdata, handles)

abr=evalin('base','abierto');

if(abr==1)
    save_system('SIMU_ROBOT.mdl');
    close_system('SIMU_ROBOT.mdl');
    abr=0;
    assignin('base','abierto',abr);
end

vertices=[];

cir=[];
circunferencia=[];

interpol=[];
interpolacion=[];

 trayectoriax=[];
 trayectoriay=[];
 simular=[];
 servo=[];

ndiv=10;
poli=evalin('base','pol');
nlados=evalin('base','nlados');
radio=evalin('base','radio');
if poli==1
    
    tita = [0:(2*pi/nlados):2*pi]-pi; 
    
    x =14.7+radio*cos(tita);
    y =radio*sin(tita); 
    
    for d=1: nlados
    vert(1,d)=x(d);
    vert(2,d)=y(d);
   
    end
    
    vertices=vert';
    
    assignin('base','vertices',vertices);
    
    for il=1:nlados
        
        if(il==nlados)
            
            xi=x(il);
            yi=y(il);
            xf=x(1);
            yf=y(1);
          
        else
            xi=x(il);
            yi=y(il);
            xf=x(il+1);
            yf=y(il+1);
            
        end
        
        varx=(xf-xi)/ndiv;  
        vary=(yf-yi)/ndiv;
        
        for id=1: ndiv+1
            
            if(id==ndiv+1)
                interpol((il-1)*3+1,id)=xf;
                interpol((il-1)*3+2,id)=yf;
                interpol((il-1)*3+3,id)=0;
            
            else   
            interpol((il-1)*3+1,id)=xi+(varx)*(id-1);
            interpol((il-1)*3+2,id)=yi+(vary)*(id-1);
            interpol((il-1)*3+3,id)=0;                    
            end
            
        end
    end
    interpol((nlados-1)*3+3,ndiv+1)=1;
    
    interpolacion=interpol';
    assignin('base','interpolacion',interpolacion);
    
   
    clear trayectoriax;
    clear trayectoriay;
    clear simular;
    clear servo;
    
    for ic=1:ndiv*nlados+nlados
        
        trayectoriax(ic,1)=3*ic;
        trayectoriay(ic,1)=3*ic;
        simular(ic,1)=3*ic;
        servo(ic,1)=3*ic;
        
    end
        
        for il=1:nlados
             for id=1: ndiv+1
                trayectoriax(id+(ndiv+1)*(il-1),2)= interpolacion(id,(il-1)*3+1)
                trayectoriay(id+(ndiv+1)*(il-1),2)= interpolacion(id,(il-1)*3+2);
                simular(id+(ndiv+1)*(il-1),2)= interpolacion(id,(il-1)*3+3);
                servo(id+(ndiv+1)*(il-1),2)=0;
                if(il==nlados)
                    if(id==ndiv+1)
                        servo(id+(ndiv+1)*(il-1),2)=15;
                    end
                end
              end
             
        end
        
    assignin('base','trayectoriax',trayectoriax);
    assignin('base','trayectoriay',trayectoriay);
    assignin('base','simular',simular);
    assignin('base','servo',servo);
    
    axes(handles.axes4)
    plot(x,y)
    grid on
    
    
    axes(handles.axes1) %%si lo pongo dentro dibuja puntos en tiempo real
    for n=1:nlados
        for i=1:ndiv+1
            plot(interpolacion(i,(n-1)*3+1),interpolacion(i,(n-1)*3+2),'+r')
            hold on
            grid on
        end
    end
    hold off
        
    
    
    
end

if poli==0
    tita = (-pi/2:0.06:2.01*pi); 
    x =14.7+radio*cos(tita);
    y =radio*sin(tita);
    
    for d=1: (2.01*pi/0.06)+1
        cir(1,d)=x(d);
        cir(2,d)=y(d);
        cir(3,d)=0;
        cir(4,d)=0;
        aux=d;
   
    end
    cir(3,aux)=1;
    cir(4,aux)=15;
    
    circunferencia=cir';
    assignin('base','circunferencia',circunferencia);
    
     clear trayectoriax;
     clear trayectoriay;
     clear simular;
     clear servo;
     
     for d=1: (2.01*pi/0.06)+1
         
         trayectoriax(d,1)=d;
         trayectoriax(d,2)=circunferencia(d,1);
         
         trayectoriay(d,1)=d;
         trayectoriay(d,2)=circunferencia(d,2);
         
         simular(d,1)=d;
         simular(d,2)=circunferencia(d,3);
         
         servo(d,1)=d;
         servo(d,2)=circunferencia(d,4);
     end
    
            
    assignin('base','trayectoriax',trayectoriax);
    assignin('base','trayectoriay',trayectoriay);
    assignin('base','simular',simular);
    assignin('base','servo',servo);
     
    axes(handles.axes4)
    plot(x,y)
    grid on
    
    axes(handles.axes1) %%si lo pongo dentro dibuja puntos en tiempo real
    for d=1: (2.01*pi/0.06)+1
         
         plot(circunferencia(d,1),circunferencia(d,2),'+r')
         grid on
         hold on
    end
    hold off
         
end
if(abr==0)
    open_system('SIMU_ROBOT.mdl');
    sim('SIMU_ROBOT.mdl');         
    abr=1;
    assignin('base','abierto',abr);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit5_Callback(hObject, eventdata, handles)


function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
