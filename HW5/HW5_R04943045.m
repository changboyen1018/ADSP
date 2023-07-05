%====ADSP HW5====%
function [ A, B ] = NTTm( N, M )
A = ones(N);
B = ones(N);
% check for error
if ~isprime(M)
error('M needs to be a prime number.');
end
if mod(M-1,N)~=0
error('N needs to be a factor of M-1.');
end
% implementing table-lookup
table_mult = mod((1:M)'*(1:M),M);
table_power = zeros(M);
table_power(:,1) = mod((1:M)',M);
for i = 2:M
table_power(:,i) = mod(table_power(:,i-1).*(1:M)',M);
end
% calculate alpha from the candinates
candinates = find(table_power(2:end,N)==1)+1;
i = 1;
while(1)
if ~sum(ismember(table_power(candinates(i),1:N-1),1))
alpha = candinates(i);
break;
else
i = i+1;
end
end
% constructing the forward matrix A
index = reshape(mod(repmat(1:N-1,N-1,1).*repmat((1:N-1)',1,N-1),N),1,(N-1)*(N-1));
index(find(index==0))=N;
result = table_power(alpha,index);
A(2:end,2:end) = reshape(result,N-1,N-1)';
% constructing the inverse matrix B
if N == M-1
N_inv = N;
else
N_inv = find(table_mult(N,:)==1);
end
alpha_inv = find(table_mult(alpha,:)==1);
result_inv = table_power(alpha_inv,index);
B(2:end,2:end) = reshape(result_inv,N-1,N-1)';
B = mod(B*N_inv,M);
