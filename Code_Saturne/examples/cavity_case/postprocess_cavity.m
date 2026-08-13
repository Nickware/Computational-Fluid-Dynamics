function postprocess_cavity(data_file)
  % Postprocesado básico del caso de cavidad en Octave.
  % Espera un archivo CSV con columnas: x,y,u,v,p

  if nargin < 1
    data_file = 'results/cavity.csv';
  end

  if ~exist(data_file, 'file')
    fprintf('No se encontró el archivo: %s\n', data_file);
    fprintf('Ejemplo de uso: postprocess_cavity(''results/cavity.csv'')\n');
    return;
  end

  data = dlmread(data_file, ',', 1, 0);
  x = data(:, 1);
  y = data(:, 2);
  u = data(:, 3);
  v = data(:, 4);
  p = data(:, 5);

  x_mid = x(abs(y - 0.5) < 1e-6);
  y_mid = y(abs(x - 0.5) < 1e-6);
  u_mid = u(abs(y - 0.5) < 1e-6);
  v_mid = v(abs(x - 0.5) < 1e-6);

  fprintf('Perfil central en x=0.5:\n');
  fprintf('  max(u): %.4f\n', max(u_mid));
  fprintf('  max(v): %.4f\n', max(v_mid));

  kinetic_energy = mean(0.5 * (u.^2 + v.^2));
  fprintf('Energía cinética media: %.4f\n', kinetic_energy);

  % Se recomienda visualizar como una gráfica básica del campo
  figure;
  plot(x_mid, u_mid, 'b-', 'LineWidth', 2);
  hold on;
  plot(y_mid, v_mid, 'r--', 'LineWidth', 2);
  xlabel('coordenada');
  ylabel('velocidad');
  legend('u(x,0.5)', 'v(0.5,y)');
  title('Perfiles de velocidad en cavidad 2D');
  grid on;
end
