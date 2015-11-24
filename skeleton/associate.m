% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs:
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
% FILL IN HERE

%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]

  % The number of measurements n
  n = size(z,2);

  % The number of landmarks N
  N = size(W,2);

  % The number of particles M
  M = size(S_bar, 2);

  z_bar = zeros(2, M, N);

  Psi = zeros(1, n, M);

  % nu cannot be transposed, so Q must be modified in order for the
  % exponent multiplication to be feasible
  diag_inverse_Q = diag(inv(Q));
  Q_new = repmat(diag_inverse_Q, [1 N M]);

  % Predict measurement
  for k = 1:N
    z_bar(:,:,k) = observation_model(S_bar, W, k);
  end

  % Rearrange to 2xNxM
  z_bar = permute(z_bar, [1,3,2]);

  % Keep it outside the for loop to economize on time
  norm_exp = (2*pi*sqrt(det(Q)))^(-1);

  % Calculate the innovation
  for i = 1:n
    %size(z(1,i))
    %size(z_bar(1,:,:))
    %size(z(2,i))
    %size(z_bar(2,:,:))

    nu(1,:,:) = z(1,i) - z_bar(1,:,:);
    nu(2,:,:) = z(2,i) - z_bar(2,:,:);

    nu(2,:,:) = mod(nu(2,:,:) + pi, 2*pi) - pi;

    % nu cannot be transposed!
    % plus, nu' * Q_ * nu == sum(nu .* Q_ .* nu)
    %size(Psi(1,i,:))                                                % 1 1 10000
    %size(norm_exp * exp(sum(-0.5 .* nu .* Q_new .* nu, 1)))        % 1 17 10000

     Psi(1,i,:) = max(norm_exp * exp(sum(-0.5 .* nu .* Q_new .* nu, 1)));

  end

  outlier = mean(reshape(Psi, n, M), 2) <= Lambda_psi;

end
