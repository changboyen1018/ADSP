%design a minimax highpass FIR filter 
function hw()

% Coefficients of the function
N=21;
k=(N-1)/2; %選取幾個點10+2個
delta=0.0001;

fs = 8000;
fh=2000/fs; % 0.25
fd=1800/fs; % 0.225
fl=1600/fs; % 0.2

%Initialial
A=zeros(12,12);
S=zeros(12,1);
H=zeros(12,1);

F=[0; 0.03; 0.05; 0.10; 0.15; 0.2; 0.25; 0.30; 0.35; 0.40; 0.45; 0.50];
f=0:delta:0.5
H= F>=fh;
Hd= f>=fd;

Wp=1.0*(f>=fh);
Ws=0.8*(f<=fl);
Wf = @(f) 1.0*(f>=fh) + 0.8*(f<=fl);
%Wf = Wp+Ws;
iteration = 1;
max_errors = [];

% While loop
% Step2
E1 = 99;
E0 = 1;
while abs(E1 - E0) > delta
    %for k=1:1:1
    for i = 1:1:12
        for j = 1:1:11
            A(i, j) = cos(2 * pi * (j - 1) * F(i));
        end
        A(i, 12) = (-1)^(i - 1) / Wf(F(i)); %This line is needed to update the A matrix correctly.
    end
    S = A \ H;    %Sol of A * S = HS
	disp(S);

% Step3 Compute err(F)
    Rf=0;
    for i=1:11
        %Rf=Rf+S(i)*cos(2*pi*(i-1)*F(i));
	    Rf=Rf+S(i)*cos(2*pi*(i-1)*f);
    end
    err=(Rf-Hd).*Wf(f);
		%err=(Rf-Hd).*Wf;

% Step4 %%%%%
    q=1
    for i=2:1:5000 
        if (err(i)>err(i+1) && err(i)>err(i-1)) || (err(i)<err(i+1) && err(i)<err(i-1))
                F(q)=delta*i;
                q=q+1;
        end
    end
    %也可以用 F(1:length(f) - 1) = delta * (1:(length(f) - 1));

% Step5

    % Update E0 and E1
	fprintf('Iteration: %d, Max Error: %f\n', iteration, E1);
    iteration = iteration + 1;
	%E0 = max(abs(S(1:11)));
	E0 = E1;
	max_errors = [max_errors; err];
		%fprintf('Iteration: %d, Max Error: %f\n', iteration, E1);
    %iteration = iteration + 1;
end

% Calculate the new E1 value
E1 = max(abs(S(1:11)));

% Step 6 - Compute the final filter coefficients
	h(k+1)=S(0+1);
	%h(k+1) = 2 * sum(S(1:11));
	for n = 1:k
	    h(k+1+n) = S(n+1)/2;
	    h(k+1-n) = S(n+1)/2;

    end

% Plot Frequency Response
figure;
freqz(h, 1, 512, fs);
title('Frequency Response');
xlabel('frequency(Hz)');
x=0:1:20;
% Plot Impulse Response (Added)
figure; 
stem(h, 'filled'); 
xlabel('times'); 
ylabel('h[n]'); 
title('Impulse Response h[n]');
xlim([-1 21])
% Plot Maximal Error for Each Iteration (Added) --------
% Plot Errors for Each Iteration (Updated)
% Plot Maximal Error for Each Iteration
figure;
plot(max_errors, 'o-');
xlabel('Iteration');
ylabel('Max Error');
title('Maximal Error for Each Iteration');

% Display the filter coefficients
disp(h);

end

% Display the filter coefficients
%disp(h);
%plot(R,Hd)
%plot(h)