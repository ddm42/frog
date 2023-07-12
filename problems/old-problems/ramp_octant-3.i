#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
    displacements = 'disp_x disp_y disp_z'
    large_kinematics = true
  []
  
  [Variables]
    [disp_x] 
    []
    [disp_y]
    []
    [disp_z]
    []
  []

  [AuxVariables]
    [pressure]
      order = CONSTANT
      family = MONOMIAL
    []
  []
  
  [Mesh]
    file = /home/ddm42/projects/frog/mesh/sphericalOctant-mm.msh
  []
  
  [Kernels]
    [sdx]
      type = TotalLagrangianStressDivergence
      variable = disp_x
      component = 0

    []
    [sdy]
      type = TotalLagrangianStressDivergence
      variable = disp_y
      component = 1

    []
    [sdz]
      type = TotalLagrangianStressDivergence
      variable = disp_z
      component = 2
    []
  []
    
    #
    # Added boundary/loading conditions
    # https://mooseframework.inl.gov/modules/tensor_mechanics/tutorials/introduction/step02.html
    #
    [BCs]
      [bottom_x]
        type = DirichletBC
        variable = disp_x
        boundary = 75
        value = 0 # meters
      []
      [bottom_y]
        type = DirichletBC
        variable = disp_y
        boundary = 74
        value = 0 # meters
      []
      [bottom_z]
        type = DirichletBC
        variable = disp_z
        boundary = 67
        value = 0
      []
      [Pressure]
        [right]
          boundary = 65
          function = 4.3*t # 14.5 kPa = 148.1 cm. H2O
        []
      []
    []

    [AuxKernels]
      [pressure]
        type = FunctionAux
        variable = pressure
        function = '4.3*t'
        boundary = 65
        execute_on = TIMESTEP_END
      []
    []
    
    [Materials] # StVenantKirchhoffStress Modelfrog/problems/hyperelastic_cube.i
      [stress]
        type = ComputeNeoHookeanStress
        mu = 3.36 # kPa
        lambda = 164.4 # kPa
        # Equations relating shear E and v to Lame params:
        # https://encyclopediaofmath.org/wiki/Lam%C3%A9_constants#:~:text=The%20Lam%C3%A9%20constants%20are%20connected,is%20the%20modulus%20of%20shear.
        # 
        # Paper with E of bladder:
        # https://link.springer.com/content/pdf/10.1007/BF02457796.pdf?pdf=button 
        #
        # Paper claiming poisson ratio is about 0.5 (don't trust it):
        # https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4285607/#:~:text=These%20studies%20treated%20bladder%20as,8%2C%2051%2C%2052%5D.
      []
      [strain]
        type = ComputeLagrangianStrain
      []
    []
  
    # # consider all off-diagonal Jacobians for preconditioning
    # [Preconditioning]
    #   [SMP]
    #     type = SMP
    #     full = true
    #   []
    # []
  
    [Executioner]
      type = Transient
      solve_type = NEWTON
      end_time = 1 # <--- failing at .1655
      dt = .005
      petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
      petsc_options_value = 'lu mumps'
    []
  
    
    [Outputs]
      exodus = true
      #print_linear_residuals = false
    []