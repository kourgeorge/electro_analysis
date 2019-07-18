function [f, df, hessian] = ln_poisson_model(param,data,modelType)

X = data{1}; % subset of A
Y = data{2}; % number of spikes

% compute the firing rate
u = X * param;
rate = exp(u);

% roughness regularizer weight - note: these are tuned using the sum of f,
% and thus have decreasing influence with increasing amounts of data
% TODO: fix these weights.
b_pos = 0; b_arm = 0; b_rew = 0; b_armtype = 0;

% start computing the Hessian
rX = bsxfun(@times,rate,X);       
hessian_glm = rX'*X;

%% find the P, H, S, or T parameters and compute their roughness penalties

% initialize parameter-relevant variables
J_ev = 0; J_ev_g = []; J_ev_h = []; 
J_arm = 0; J_arm_g = []; J_arm_h = [];  
J_rew = 0; J_rew_g = []; J_rew_h = [];  
J_armType = 0; J_armType_g = []; J_armType_h = [];  

% find the parameters
numPos = 5; numArms = 4; numRew = 1; numArmType = 1; % hardcoded: number of parameters
[param_pos,param_arms,param_rew,param_armtypes] = find_param(param,modelType,numPos,numArms,numRew,numArmType);

% compute the contribution for f, df, and the hessian
if ~isempty(param_pos)
    [J_ev,J_ev_g,J_ev_h] = rough_penalty_1d(param_pos,b_pos);
end

if ~isempty(param_arms)
    [J_arm,J_arm_g,J_arm_h] = rough_penalty_1d(param_arms,b_arm);
end

if ~isempty(param_rew)
    [J_rew,J_rew_g,J_rew_h] = rough_penalty_1d(param_rew,b_rew);
end

if ~isempty(param_armtypes)
    [J_armType,J_armType_g,J_armType_h] = rough_penalty_1d(param_armtypes,b_armtype);
end

%% compute f, the gradient, and the hessian 

f = sum(rate-Y.*u) + J_ev + J_arm + J_rew + J_armType;
df = real(X' * (rate - Y) + [J_ev_g; J_arm_g; J_rew_g; J_armType_g]);
hessian = hessian_glm + blkdiag(J_ev_h,J_arm_h,J_rew_h,J_armType_h);


%% smoothing functions called in the above script
function [J,J_g,J_h] = rough_penalty_2d(param,beta)

    numParam = numel(param);
    D1 = spdiags(ones(sqrt(numParam),1)*[-1 1],0:1,sqrt(numParam)-1,sqrt(numParam));
    DD1 = D1'*D1;
    M1 = kron(eye(sqrt(numParam)),DD1); M2 = kron(DD1,eye(sqrt(numParam)));
    M = (M1 + M2);
    
    J = beta*0.5*param'*M*param;
    J_g = beta*M*param;
    J_h = beta*M;

function [J,J_g,J_h] = rough_penalty_1d_circ(param,beta)
    
    numParam = numel(param);
    D1 = spdiags(ones(numParam,1)*[-1 1],0:1,numParam-1,numParam);
    DD1 = D1'*D1;
    
    % to correct the smoothing across first and last bin
    DD1(1,:) = circshift(DD1(2,:),[0 -1]);
    DD1(end,:) = circshift(DD1(end-1,:),[0 1]);
    
    J = beta*0.5*param'*DD1*param;
    J_g = beta*DD1*param;
    J_h = beta*DD1;

function [J,J_g,J_h] = rough_penalty_1d(param,beta)

    numParam = numel(param);
    D1 = spdiags(ones(numParam,1)*[-1 1],0:1,numParam-1,numParam);
    DD1 = D1'*D1;
    J = beta*0.5*param'*DD1*param;
    J_g = beta*DD1*param;
    J_h = beta*DD1;
   
%% function to find the right parameters given the model type
function [param_pos,param_arms,param_rew,param_armtypes] = find_param(param,modelType,numPos,numArms,numRew,numArmType)

param_pos = []; param_arms = []; param_rew = []; param_armtypes = [];

if all(modelType == [1 0 0 0]) 
    param_pos = param;
elseif all(modelType == [0 1 0 0]) 
    param_arms = param;
elseif all(modelType == [0 0 1 0]) 
    param_rew = param;
elseif all(modelType == [0 0 0 1]) 
    param_armtypes = param;

elseif all(modelType == [1 1 0 0])
    param_pos = param(1:numPos);
    param_arms = param(numPos+1:numPos+numArms);
elseif all(modelType == [1 0 1 0]) 
    param_pos = param(1:numPos);
    param_rew = param(numPos+1:numPos+numRew);
elseif all(modelType == [1 0 0 1]) 
    param_pos = param(1:numPos);
    param_armtypes = param(numPos+1:numPos+numArmType);
elseif all(modelType == [0 1 1 0]) 
    param_arms = param(1:numArms);
    param_rew = param(numArms+1:numArms+numRew);
elseif all(modelType == [0 1 0 1]) 
    param_arms = param(1:numArms);
    param_armtypes = param(numArms+1:numArms+numArmType);
elseif all(modelType == [0 0 1 1])  
    param_rew = param(1:numRew);
    param_armtypes = param(numRew+1:numRew+numArmType);
    
elseif all(modelType == [1 1 1 0])
    param_pos = param(1:numPos);
    param_arms = param(numPos+1:numPos+numArms);
    param_rew = param(numPos+numArms+1:numPos+numArms+numRew);
elseif all(modelType == [1 1 0 1]) 
    param_pos = param(1:numPos);
    param_arms = param(numPos+1:numPos+numArms);
    param_armtypes = param(numPos+numArms+1:numPos+numArms+numArmType);
elseif all(modelType == [1 0 1 1]) 
    param_pos = param(1:numPos);
    param_rew = param(numPos+1:numPos+numRew);
    param_armtypes = param(numPos+numRew+1:numPos+numRew+numArmType);
elseif all(modelType == [0 1 1 1]) 
    param_arms = param(1:numArms);
    param_rew = param(numArms+1:numArms+numRew);
    param_armtypes = param(numArms+numRew+1:numArms+numRew+numArmType);
    
elseif all(modelType == [1 1 1 1])
    param_pos = param(1:numPos);
    param_arms = param(numPos+1:numPos+numArms);
    param_rew = param(numPos+numArms+1:numPos+numArms+numRew);
    param_armtypes = param(numPos+numArms+numRew+1:numPos+numArms+numRew+numArmType);
end
    


