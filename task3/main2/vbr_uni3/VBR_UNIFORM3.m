function [ total_packets, total_bytes, run_time ] = VBR_UNIFORM3( sim_time, A, B, C, D, sim_flag ) 
if sim_flag == 2 % off time station is sleeping
    total_packets = 0;
    total_bytes = 0;
    run_time = sim_time;
    return;
end

flag=true; 
T=0; 
Event_List=[1,2;1,sim_time]; 
total_packets=0; 
total_bytes=0; 

%custom entries
packet_size = [];
interarrival_time = [];
time_counter = 1;
size_counter = 1;

%A = input('give limit A for packet size: '); %64
%B = input('give limit B for packet size: '); %1518
[ packet_size ]=uni( packet_size, sim_time, 13,  5, 5, A, B );
%C = input('give limit A for interarrival time: '); %1
%D = input('give limit B for interarrival time: '); %10
[ interarrival_time ] = uni(interarrival_time, sim_time, 13,  5, 5, C, D );

packet_size = fix(packet_size); %packet size must be fixed

while flag 
    event=Event_List(1,1); 
    if event==1    
[T,Event_List,total_packets,total_bytes, size_counter, time_counter]=Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time, time_counter, size_counter); 

    elseif event==2 
        [T,flag]=Event2(T,flag,Event_List); 
        
    end 
     
    Event_List(:,1)=[]; 
    Event_List=(sortrows(Event_List',[2,1]))'; 
end %end looop

packets_per_second = total_packets/T;
bps = total_bytes*8/T; 
run_time = sim_time;

end %end func


function[T,Event_List,total_packets,total_bytes, size_counter, time_counter] = Event1(T,Event_List,total_packets,total_bytes,packet_size,interarrival_time, time_counter, size_counter) 
T=Event_List(2,1); 
total_packets=total_packets+1; 
total_bytes=total_bytes + packet_size(size_counter); 
size_counter = size_counter + 1;
L=size(Event_List); 
Event_List(1,L(2)+1)=1; 
Event_List(2,L(2)+1)=T+interarrival_time(time_counter); 
time_counter = time_counter + 1;
end 

function [T,flag]=Event2(T,flag,Event_List) 
T=Event_List(2,1); 
flag=false; 
disp('Simulation End') 
end