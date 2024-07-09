function varargout = Main_EV_Fault(varargin)
% MAIN_EV_FAULT MATLAB code for Main_EV_Fault.fig
%      MAIN_EV_FAULT, by itself, creates a new MAIN_EV_FAULT or raises the existing
%      singleton*.
%
%      H = MAIN_EV_FAULT returns the handle to a new MAIN_EV_FAULT or the handle to
%      the existing singleton*.
%
%      MAIN_EV_FAULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_EV_FAULT.M with the given input arguments.
%
%      MAIN_EV_FAULT('Property','Value',...) creates a new MAIN_EV_FAULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_EV_Fault_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_EV_Fault_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_EV_Fault

% Last Modified by GUIDE v2.5 13-Apr-2024 20:51:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_EV_Fault_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_EV_Fault_OutputFcn, ...
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


% --- Executes just before Main_EV_Fault is made visible.
function Main_EV_Fault_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_EV_Fault (see VARARGIN)

% Choose default command line output for Main_EV_Fault
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_EV_Fault wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_EV_Fault_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

clc;
delete(instrfindall);

% File Path
addpath(genpath('Train_Data'));


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
clear all;
close all;
delete(instrfindall);

% --- Executes on button press in serial_start.
function serial_start_Callback(hObject, eventdata, handles)
% hObject    handle to serial_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global S COMPORT;

% Select the Com port number
index_selected = get(handles.com_portno,'Value');
% file_list = get(handles.com_portno,'String');
% COMPORT = file_list{index_selected};
COMPORT = get(handles.com_portno,'String');
% Serial Read
S=serial(COMPORT,'Baudrate',9600);
fopen(S);

msgbox('Serial Port Connected...','Serial Port');


% --- Executes on button press in serial_stop.
function serial_stop_Callback(hObject, eventdata, handles)
% hObject    handle to serial_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global S;

fclose(S);
delete(S);
clear S;

delete(instrfindall);


function com_portno_Callback(hObject, eventdata, handles)
% hObject    handle to com_portno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of com_portno as text
%        str2double(get(hObject,'String')) returns contents of com_portno as a double


% --- Executes during object creation, after setting all properties.
function com_portno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_portno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sensor_data.
function sensor_data_Callback(hObject, eventdata, handles)
% hObject    handle to sensor_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global S count;
global data1 data2 data3 data4 data5 data6 data7 data8 data9 data10;

j=1;
count = 0;
data_c = 0;
mail = 0;

while(j >= count)
     
     % delete ./*.txt
     pause(1);
     data_c = data_c + 1;
     
     str = fscanf(S);
     data = char(str);

     find_value = strfind(data, '123');
     fv = find_value(1,1);
     data_value = data([fv (fv+1):end]);

     fileID = fopen('save_serial.txt','w');
     fprintf(fileID,'%s \n',data_value);
     fclose(fileID);
     % open save_serial.txt;

     fileID = fopen('save_serial.txt','r');
     formatSpec = '%f %f %f %f %f %f %f %f';
     sizeA = [11 Inf];
     scan_serial = fscanf(fileID,formatSpec, sizeA);
     
     clc;
     scan_serial = scan_serial';
     
%               
     data1 = scan_serial(:,2);   % Battery Temp
     data2 = scan_serial(:,3);   % Panel Temp
     data3 = scan_serial(:,4);      % Battery Voltage
     data4 = scan_serial(:,5);      % Panel Voltage
     data5 = scan_serial(:,6);      % Engine Temp
%      data6 = scan_serial(:,7);      % Env. Humi
%      data7 = scan_serial(:,8);      % Env. Temp
%      data8 = scan_serial(:,9);      % In. Humi
%      data9 = scan_serial(:,10);     % In. Temp
%      data10 = scan_serial(:,11);    % Engine Vibration

data8 = 5;
data9 = 5;
data10 = 5;

% data6 = 0;
     
     datanum1 = data1;
     datanum2 = data2;
     datanum3 = data3;
     datanum4 = data4;
     datanum5 = data5;
     datanum6 = data6;
     datanum7 = data7;
     datanum8 = data8;
     datanum9 = data9;
     datanum10 = data10;
     
     t = datestr(now);
     date = datenum(t);
     
%      disp(data_c)
     data_del = [date datanum1 datanum2 datanum3 datanum4 datanum5 datanum6 datanum7 datanum8 datanum9 datanum10];
%      disp (data_del)
     
     data1 = num2str(data1);
     data2 = num2str(data2);
     data3 = num2str(data3);
     data4 = num2str(data4);
     data5 = num2str(data5);
     data6 = num2str(data6);
     data7 = num2str(data7); 
     data8 = num2str(data8); 
     data9 = num2str(data9); 
     data10 = num2str(data10); 
     
     data_cel = (['Battery Temperature - ' data1, 10, 'Engine Temperature - ' data2, 10,... 
                  'Battery Voltage     - ' data3, 10, 'Fire               - ' data4, 10,...
                  'Engine Vibration    - ' data5  ]);
     
     
     [dataa(data_c,:)] = data_del;
     save('Train_BData','dataa');
     
     set(handles.data_1,'String',data1);
     set(handles.data_2,'String',data2);
     set(handles.data_3,'String',data3);
     set(handles.data_4,'String',data4);
     set(handles.data_5,'String',data5);     
     
     api_key = get(handles.api,'String');
     
     if isempty(api_key)
         str = 'No API';
         stdd = '0';
         set(handles.text10,'String',str);
         set(handles.entry_status,'String',stdd);
%          clear str api_key;
         
     else
%          NGRHK4AENEVPELQU
         pause(1);
         fullURL = ['https://api.thingspeak.com/update?',...
             'api_key=',api_key,...
             '&field1=',data1,...
             '&field2=',data2,...
             '&field3=',data3,...
             '&field4=',data4,...
             '&field5=',data5,...
         ];
     disp(fullURL);
     str = urlread(fullURL);
     disp(['Entries - ',str]);
     std = str2double(str);
%      disp(str);
     
     if(std >= 1)
         set(handles.entry_status,'String',std);
     end
     end
     
     
% %  Email
     mail_id = get(handles.email_id,'String');
     
     if isempty(mail_id)
         disp('No Mail ID Updated...');
     else
         disp(['Entered Mail ID - ',mail_id]);
         subject = ['Alert Message Temperature High... ',datestr(now)];
         
         if(datanum1 >= 37)
            saveas(gcf,'output','bmp');
            disp('Mail Sending...')
            attachment='output.bmp';
            message = data_cel;
            disp(message);
            disp('Mail Sent...')
            disp(mail)
            if(mail == 0)
                send_mail_message(mail_id,subject,message,attachment);
                mail = mail+1;
            end
         
         else
             mail = 0;
         end
         
         
     end
     
     disp('Sensor Data')
     disp(data_cel)

%      fprintf('Sensor Data  \n');
%      fprintf('Bat. Temperature  : %0.2f \n', data1);
%      fprintf('Panel Temperature : %0.2f \n', data2);
%      fprintf('Bat. Voltgae      : %0.2f \n', data3);
%      fprintf('Panel Voltage     : %0.2f \n', data4);
%      fprintf('Engine Temperature: %0.2f \n', data5);
%      fprintf('Envi. Temperature : %0.0f \n', data6);
%      fprintf('Envi. Humidity    : %0.0f \n', data7);
%      fprintf('Inside Temperature: %0.0f \n', data8);
%      fprintf('Inside Humidity   : %0.0f \n', data9);
%      fprintf('Engine Vibration  : %0.0f \n', data10);
     pause(0.5)

end

% --- Executes on button press in stop_data.
function stop_data_Callback(hObject, eventdata, handles)
% hObject    handle to stop_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global count;

count = count+2;

function data_1_Callback(hObject, eventdata, handles)
% hObject    handle to data_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_1 as text
%        str2double(get(hObject,'String')) returns contents of data_1 as a double


% --- Executes during object creation, after setting all properties.
function data_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_2_Callback(hObject, eventdata, handles)
% hObject    handle to data_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_2 as text
%        str2double(get(hObject,'String')) returns contents of data_2 as a double


% --- Executes during object creation, after setting all properties.
function data_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_3_Callback(hObject, eventdata, handles)
% hObject    handle to data_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_3 as text
%        str2double(get(hObject,'String')) returns contents of data_3 as a double


% --- Executes during object creation, after setting all properties.
function data_3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_4_Callback(hObject, eventdata, handles)
% hObject    handle to data_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_4 as text
%        str2double(get(hObject,'String')) returns contents of data_4 as a double


% --- Executes during object creation, after setting all properties.
function data_4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_5_Callback(hObject, eventdata, handles)
% hObject    handle to data_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_5 as text
%        str2double(get(hObject,'String')) returns contents of data_5 as a double


% --- Executes during object creation, after setting all properties.
function data_5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_6_Callback(hObject, eventdata, handles)
% hObject    handle to data_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_6 as text
%        str2double(get(hObject,'String')) returns contents of data_6 as a double


% --- Executes during object creation, after setting all properties.
function data_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function api_Callback(hObject, eventdata, handles)
% hObject    handle to api (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of api as text
%        str2double(get(hObject,'String')) returns contents of api as a double


% --- Executes during object creation, after setting all properties.
function api_CreateFcn(hObject, eventdata, handles)
% hObject    handle to api (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function entry_status_Callback(hObject, eventdata, handles)
% hObject    handle to entry_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of entry_status as text
%        str2double(get(hObject,'String')) returns contents of entry_status as a double


% --- Executes during object creation, after setting all properties.
function entry_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to entry_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function email_id_Callback(hObject, eventdata, handles)
% hObject    handle to email_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of email_id as text
%        str2double(get(hObject,'String')) returns contents of email_id as a double


% --- Executes during object creation, after setting all properties.
function email_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to email_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mobile_no_Callback(hObject, eventdata, handles)
% hObject    handle to mobile_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mobile_no as text
%        str2double(get(hObject,'String')) returns contents of mobile_no as a double


% --- Executes during object creation, after setting all properties.
function mobile_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mobile_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on api and none of its controls.
function api_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to api (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
