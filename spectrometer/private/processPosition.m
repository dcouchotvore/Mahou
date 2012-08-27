function [position,bin] = processPosition(x_in,y_in,bin_zero,initialPosition)
global fringeToFs
flag_debug = true;

%mimic the objects
nShots = length(x_in);
x_in = x_in - mean(x_in);
y_in = y_in - mean(y_in);

%show some points if we are debugging
if flag_debug
figure(10),clf,
plot(x_in,...
    y_in,'-o')
hold on,
plot(x_in(1),...
    y_in(1),'o',...
    'MarkerFaceColor',[0 0 1]);
hold off
ax = axis;
l=line([0 1;0 -1],[-1 0;1 0]);
set(l,'Color',[0.2 0.2 0.2])
axis square
axis(ax);
drawnow
end

%this algorithm requires >4 points per cycle. It will fail if
%points cross more than 2 axes at a time
%try to vectorize
x = x_in(1,2:end);
y = y_in(1,2:end);
last_x = x_in(1,1:end-1);
%last_y = obj.sample.data.external(16,1:end-1); %SGR algorithm
%doesn't use last_ys

incr = zeros(1,nShots-1);
%Here is my truth table idea. We count up if y>0 AND last_x<0
%AND x>=0. Call these a b and c (a AND b AND c). We count down
%if y>0 AND last_x>=0 AND x<0 (a AND ~b AND ~c). Use these
%rules to make increment plus or minus 1. Note the use of >= to
%define x=0 to be in the (+,+) quadrant of the x-y plane. This
%makes the NOT conditions exclusive. Probably never will happen
%but whatever.
a = y>0;
b = last_x<0;
c = x>=0;
incr(a & b & c) = 1;
incr(a & ~b & ~c) = -1;
position = [0 cumsum(incr)]*fringeToFs + initialPosition;
bin = timeFsToBin(position,bin_zero);

