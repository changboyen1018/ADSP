% User input for the signals
prompt = 'Enter the first signal (e.g., [1 2 3 4]): ';
x = input(prompt);

prompt = 'Enter the second signal (e.g., [1 2 3 4]): ';
y = input(prompt);

% Check if the signals have the same length
if length(x) ~= length(y)
    error('The two signals must have the same length.');
end

% Compute and display the FFTs of the signals
[Fx, Fy] = fftreal(x, y);
disp('FFT of the first signal:');
disp(Fx);
disp('FFT of the second signal:');
disp(Fy);

% Function to compute the FFTs
function [Fx, Fy] = fftreal(x, y)
    N = length(x);

    % Combine the two real signals into a complex signal
    z = x + 1i*y;

    % Compute the FFT of the combined signal
    Fz = fft(z, N);

    % Recover the FFT of the original signals
    Fx = 0.5 * (Fz + conj([Fz(1), fliplr(Fz(2:end))]));
    Fy = -0.5i * (Fz - conj([Fz(1), fliplr(Fz(2:end))]));
end
