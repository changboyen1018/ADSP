function HW2_R11945072()
    clear
    close all
    
    k = input('Enter integer k = ');
    n = 2 * k + 1;
    F = (0:(n-1)) / n;
    
    H = compute_filter(n, F);
    r = compute_impulse_response(H);
    r_shifted = shift_impulse_response(r, k, n);
    
    plot_results(F, H, r, r_shifted, n);
end

function H = compute_filter(n, F)
    H = zeros(1, n);
    for i = 1:(n+1)/2
        H(i) = 1j * 2 * pi * F(i);
    end
    for i = ((n+1)/2 + 1):n
        H(i) = conj(H((n+1) - i));
    end
end

function r = compute_impulse_response(H)
    r = ifft(H);
end

function r_shifted = shift_impulse_response(r, k, n)
    r_shifted = [r(k+2:n) r(1:k+1)];
end

function plot_results(F, H, r, r_shifted, n)
    figure;
    stem(F, imag(H));
    title('Imaginary part of H(F)');
    xlabel('Frequency (F)');
    ylabel('Imaginary part of H(F)');
    
    figure;
    n1 = 0:n-1;
    stem(n1, r);
    title('Impulse response (r)');
    xlabel('n');
    ylabel('r[n]');
    
    figure;
    n2 = (-n+1)/2:(n-1)/2;
    stem(n2, r_shifted);
    title('Shifted impulse response (r_{shifted})');
    xlabel('n');
    ylabel('r_{shifted}[n]');
end
