% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs:
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)
% FILL IN HERE

%BE CAREFUL TO NORMALIZE THE FINAL WEIGHTS

  % Squeeze Psi to n x M dimensions
  psi_new = squeeze(Psi);

  % Find the indices of the outliers
  outliers_indices = find(outlier);

  psi_new(outliers_indices,:) = 1;

  w = prod(psi_new);

  % Normalize
  w_sum = sum(w);
  w = w / w_sum;

  S_bar(4,:) = w;

end
