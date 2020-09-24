%rocket.m
%program to solve the variable mass rocket equation in the
%presence of a gravitational force from a massive body
clear;
G=6.67e-11;                    %universal gravitational constant (Nm^2/kg^2)
R=6.37e6;                      %unit of distance (m) - massive body radius
m0=5.98e24;                    %unit of mass (kg) - could be the massive body
M=5.98e24/m0;                  %massive body mass in units of m0
tau=sqrt(R^3/(G*m0));          %unit of time in seconds
v0=R/tau; F0=m0*R/tau^2;       %unit of speed and unit of force
mi=2.8e6/m0;                   %initial payload+fuel mass in units of m0
ff=0.96; mp=mi*ff;             %fuel fraction, and fuel mass
Thrust=1.5*(G*mi*M/R^2)*m0^2;  %Let the Thrust be # times initial mass weight
Thrust=Thrust/F0;              %Thrust in units of force
u=0.35;                        %gas exhaust velocity in units of v0
an=55; th=an*2*pi/360;         %angle of burn determines launch angle
ux=u*cos(th); uy=u*sin(th);    %exhaust velocity components in units of v0
alpha=(Thrust/u);              %alpha in units of m0/tau
mf=mi-mp;                      %final mass is payload mass (after fuel burnout)
tfmax=(mi-mf)/alpha;           %fuel burnout time in units of tau
tmax=50*tfmax;                 %simulation run time
x0=0;y0=1;vx0=0;vy0=0;         %initial positions, speeds
ic1=[x0;vx0;y0;vy0;mi];        %initial conditions: position, velocity, rocket mass
%Use MATLAB's Runge-Kutta (4,5) formula (uncomment/comment as needed)
%opt=odeset('AbsTol',1.e-8,'RelTol',1.e-5);%user set Tolerances
%[t,w]=ode45('rocket_der',[0.0,tmax],ic1,opt,alpha,ux,uy,M,tfmax);%with set tolerance
[t,w]=ode45('rocket_der',[0.0,tmax],ic1,[],alpha,ux,uy,M,tfmax);%default tolerance
L=2.5*sqrt(x0^2+y0^2);         %window size
h=[0:0.025:2*pi];
x=cos(h);y=sin(h);             %massive body perimeter
%plot(x,y,'g'); hold on        %massive body plot if needed here
%plot(w(:,1),w(:,3))           %use this to plot all the x,y points calculated
n=length(t);                   %size of the time array
for i=1:n                      %Loop to pick the points that lie above ground
  if sqrt(w(i,1)^2+w(i,3)^2) >= 0.99 %ground is 1.0 R, include points slightly below
     nn=i;
     t1(i)=t(i);
     x1(i)=w(i,1); y1(i)=w(i,3);
     vx1(i)=w(i,2); vy1(i)=w(i,4);
  else
      break;
  end
end
%==============================%plot the magnitude of the velocity vs time
v1=sqrt(vx1.^2+vy1.^2);
r1=sqrt(x1.^2+y1.^2);
subplot(2,1,1)
plot(t1,v1,'k'), hold on
plot(t1,vx1,'b-.'),plot(t1,vy1,'r--')
ylabel('v, v_x, v_y (v_0)','FontSize',14)
str=cat(2,'Velocity Magnitude:',' \tau=',num2str(tau,3),...
          ' s, v_0=',num2str(v0,3),' m/s');
title(str,'FontSize',12)
h=legend('v','v_x','v_y',3); set(h,'FontSize',12)
subplot(2,1,2)
plot(t1,r1,'k'),hold on
plot(t1,x1,'b-.'),plot(t1,y1,'r--')
xlabel('t (\tau)','FontSize',14);ylabel('r, x, y (R)','FontSize',14)
str=cat(2,'Distance from center of body:',' \tau=',num2str(tau,3),...
          ' s, R=',num2str(R,3),' m');
title(str,'FontSize',12)
h=legend('r','x','y',0); set(h,'FontSize',12)
%==============================%simulate the points that lie above ground
figure
for i=1:nn                     
  clf;
  hold on
  plot(x1(i),y1(i),'k.')       %rocket position
  plot(x,y,'b');               %draw the massive body
  axis ([-L L -L L])           %windows size
  axis equal                   %square window
  pause(0.0125)
end
plot(x1,y1,'r:')               %trace the rocket path
xlabel('x (R)','FontSize',14);ylabel('y (R)','FontSize',14)
h=legend('Rocket','Massive Body',' Rocket path',2); set(h,'FontSize',14)
str=cat(2,'Rocket Simulation:',' \tau=',num2str(tau,3),...
          ' s, m_i=',num2str(mi*m0,3),' kg, m_p=',num2str(mp*m0,3),' kg');
title(str,'FontSize',12)
str2=cat(2,'burnout time=',num2str(tfmax,3),' \tau, stopping time=',...
            num2str(t1(nn),3),' \tau',', launch angle=',num2str(an,3),'^o');
str3=cat(2,'Thrust=',num2str(Thrust*F0,3),' N, exhaust speed=',...
            num2str(u*v0,3),' m/s, \alpha=',num2str(alpha*m0/tau,3),' kg/s');
str4=cat(2,'M=',num2str(M*m0,3),' kg');
str5=cat(2,' R=',num2str(R,3),' m');
text(-L*(1+0.2),-L*(1-0.2),str2,'FontSize',10)
text(-L*(1+0.2),-L*(1-0.1),str3,'FontSize',10)
text(-0.75,0,str4,'FontSize',10)
text(-0.75,-0.25,str5,'FontSize',10)
warning off;
Range=R*abs(atan(y1(nn)/x1(nn))-atan(y0/x0));
str6=cat(2,' Range=',num2str(Range,3),' m');
text(L*(1-0.5),L*(1-0.1),str6,'FontSize',10)
