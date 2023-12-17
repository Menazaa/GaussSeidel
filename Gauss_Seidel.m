function Gauss_Seidel()

% Line impedances
Z12 = 0.05 + 0.8i;
Z13 = 0.5 + 1.2i;
Z23 = 0.02 + 1i;

% Complex power injections (S) at each bus
S_IN_MVA = [0; -50-20i; -60-25i]; % Set the slack bus power to 0
BASE_MVA = 100;
S = S_IN_MVA ./ BASE_MVA;

% Admittance matrix
Y = zeros(3, 3);

% Calculate the diagonal elements of Y
Y(1, 1) = 1 / Z12 + 1 / Z13;
Y(2, 2) = 1 / Z12 + 1 / Z23;
Y(3, 3) = 1 / Z13 + 1 / Z23;

% Calculate the off-diagonal elements of Y
Y(1, 2) = -1 / Z12;
Y(2, 1) = Y(1, 2);

Y(1, 3) = -1 / Z13;
Y(3, 1) = Y(1, 3);

Y(2, 3) = -1 / Z23;
Y(3, 2) = Y(2, 3);


% Initial values
V = ones(3, 1); % Voltage magnitudes

V(1) = 1.05;

% Maximum number of iterations and tolerance
maxIterations = 100;

% Gauss-Seidel iterations
for iter = 1:maxIterations
    % Iterate for each bus, excluding the slack bus (starting from bus 2)
    for i = 2:3
        current = 0;
        for j = 1:3
            if(j ~= i)
                current = current + Y(i,j) * V(j);
            end
        end
        V(i) = ( (conj(S(i))/conj(V(i))) - current) / Y(i,i);
    end
end

I = 0;
for k = 1:3
    I = I + (Y(1,k) * V(k));
end
SlackBus_Power = conj(conj(V(1)) * I);

SlackBus_Power =  SlackBus_Power * BASE_MVA;


% Display results
disp('the Y Bus Matrix in (p.u):');
disp(Y);
disp('Slack Bus Power in MW:');
disp(real(SlackBus_Power));
disp('Slack Bus Reactive Power in MVAR:');
disp(imag(SlackBus_Power));
disp('Bus Voltages in (p.u):');
disp(V);
disp('Bus Voltages Magnitudes in (p.u):');
disp(abs(V));
disp('Bus Voltages Angles (in degrees):');
disp(rad2deg(angle(V)));

end
