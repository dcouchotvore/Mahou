clear All

% Create appropriate sized arrays
k=input(sprintf('please type in the number of channels you would like to change its gain  ','s')); 
Gain=cell(1,k);
Trim=cell(1,k);

% Specify which channel(s)
for m=1:k
l=input(sprintf('please specify the channel number, in successive order  ','s'));
Gain{m}=l ;
Trim{m}=l;
end

% Create the 8-byte string commands
for m=1:k
n=input(sprintf('please type in the gain value from 0 to 7 for channel %i   ',Gain{m}));
p=input(sprintf('please type in the trim value from 0 to 255 for channel %i   ',Trim{m}));
%use sprintf('IG%03i%03i',m,n)
Gain{m}=sprintf('IG%03i%03i',Gain{m},n);
Trim{m}=sprintf('IT%03i%03i',Trim{m},p);
end

disp(Gain)
disp(Trim)

s=instrfind('Type','serial','Port','COM2','Tag','');

if isempty(s)
s=serial('COM2','BaudRate',9600); 
else 
    fclose(s)
    s=s(1);
end 

%fclose(instrfindall); 


fopen(s); %open port
set(s,'Parity','none','DataBit',8,'StopBits',1,'FlowControl','software')
% send inform
for m=1:k
fprintf(s,'%s',Gain{m})
pause(0.1)
fprintf(s,'%s',Trim{m})
pause(0.1)
end

fclose(s);

%fclose(instrfindall);