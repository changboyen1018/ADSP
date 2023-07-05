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
f=0:delta:0.5;
q = 1;
for i = 1:length(f) - 1
    f(q) = delta * i;
    q = q + 1;
end
H= F>=fh;
Hd= f>=fd;

Wp=1.0*(f>fh);
Ws=0.8*(f<fl);
Wf = @(f) 1.0 * (f > fh) + 0.8 * (f <= fh & f >= fl);

iteration = 1;
max_errors = [];

% While loop
% Step2
E1 = 99;
E0 = 1;
while abs(E1 - E0) > delta || (E1-E0)<0
    for i = 1:1:12
        for j = 1:1:11
            A(i, j) = cos(2 * pi * (j - 1) * F(i));
        end
        if F(i)>=0.25
            k=1;
            A(i, 12) = (-1)^(i - 1) / k;
        else 
            k=0.8;
            A(i, 12) = (-1)^(i - 1) / k;
        %A(i, 12) = (-1)^(i - 1) / Wf(F(i)); %This line is needed to update the A matrix correctly.
    end
    S = A \ H;    %Sol of A * S = HS
    disp(S);

    % Step3 Compute err(F)
    Rf=0;
    for i=1:11
        Rf=Rf+S(i)*cos(2*pi*(i-1)*f);
    end
    err=(Rf-Hd).*Wf(f);

    % Update E0 and E1
    fprintf('Iteration: %d, Max Error: %f\n', iteration, E1);
    iteration = iteration + 1;
    E1 = E0;
    E1 = max(abs(S(1:11)));
    max_errors = [max_errors, E1];
end

% Step 6 - Compute the final filter coefficients
h = zeros(N, 1);
h(k+1) = 2 * sum(S(1:11));
for n = 1:k
h(k+1+n) = S(n+1) - S(n);
h(k+1-n) = S(n+1) + S(n);
end

% Plot Frequency Response
freqz(h, 1, 512, fs);
% Plot Impulse Response (Added)
figure;
stem(h, 'filled');
xlabel('n');
ylabel('h[n]');
title('Impulse Response h[n]');
% Plot Maximal Error for Each Iteration (Added) --------
figure;
plot(max_errors, 'o-');
xlabel('Iteration');
ylabel('Max Error');
title('Maximal Error for Each Iteration');

% Display the filter coefficients
disp(h);

end



