% function S = systematic_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = systematic_resample(S_bar)
% FILL IN HERE

  % The number of particles M
  M = size(S_bar, 2);

  r_0 = rand / M;

  % Pre-allocate S
  S = zeros(4, M);

  % The cumulative distribution of weights
  cdf = cumsum(S_bar(4,:));

  for m = 1:M
    i = find(cdf >= r_0 + (m-1) / M, 1, 'first');

    if ~isempty(i)
      S(:,m) = S_bar(:,i);
    end

    S(4,m) = 1 / M;
  end

end
