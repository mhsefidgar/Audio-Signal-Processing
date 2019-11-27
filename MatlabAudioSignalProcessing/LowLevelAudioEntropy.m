function H = LowLevelAudioEntropy(X)
% Find write data size
[m] = size(X,2);

% Preallocation
H = zeros(1,m);

for Clmn = 1:m
    % prime number
    Alphabet = unique(X(:,Clmn));
	
    % Housekeeping
    Freq = zeros(size(Alphabet));
	
    % Calculate sample frequencies
    for symbol = 1:length(Alphabet)
        Freq(symbol) = sum(X(:,Clmn) == Alphabet(symbol));
    end
	
    % Calculate probabilities of all frequencies
    P = Freq / sum(Freq);
	
    % Calculate energy entropy in bits.
    H(Clmn) = -sum(P .* log2(P));
    
end