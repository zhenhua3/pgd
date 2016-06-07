####################
# For displacement #
####################

function vtkwriter(pvd,U_a,U,step)

    ###############
    # Set up grid #
    ###############
    x = U.components[1].mesh.x; x = repmat(x,1,length(U.components[2].mesh.x))'
    y = U.components[2].mesh.x; y = repmat(y,1,length(U.components[1].mesh.x))

    X = zeros(U.components[1].mesh.nEl+1,U.components[2].mesh.nEl+1,1)
    Y = copy(X); Z = copy(X)
    X[:,:,1] = x
    Y[:,:,1] = y

    # Create file
    vtkfile = vtk_grid("./vtkfiles_elastic/step_$step",X,Y,Z,compress=false,append=false) # no compress and append due to Zlib problem

    #################
    # Displacements #
    #################
    U_nModes = size(U_a,2)

    Ux_dof = 1:2:(U.components[1].mesh.nDofs-1)
    Vx_dof = 2:2:(U.components[1].mesh.nDofs)
    Uy_dof = (U.components[1].mesh.nDofs+1):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs-1)
    Vy_dof = (U.components[1].mesh.nDofs+2):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs)

    Ux = U_a[Ux_dof,1:nModes(U)]
    Vx = U_a[Vx_dof,1:nModes(U)]

    Uy = U_a[Uy_dof,1:nModes(U)]
    Vy = U_a[Vy_dof,1:nModes(U)]

    u = Uy*Ux'
    v = Vy*Vx'

    vtkdisp = zeros(3,U.components[1].mesh.nEl+1,U.components[2].mesh.nEl+1,1)
    vtkdisp[1,:,:,1] = u
    vtkdisp[2,:,:,1] = v
    vtk_point_data(vtkfile, vtkdisp, "displacement")

    # Save to collection
    collection_add_timestep(pvd,vtkfile,float(step))

    # Save to compare with FEM
    u = u.'
    v = v.'

    meshsize = (size(u,1)-1, size(u,2)-1)

    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/u_PGD_$(nModes(U))modes_$(meshsize[1])_$(meshsize[2]).txt", u)
    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/v_PGD_$(nModes(U))modes_$(meshsize[1])_$(meshsize[2]).txt", v)

    # Save modes
    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/Ux_$(meshsize[1])_$(meshsize[2]).txt",Ux)
    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/Vx_$(meshsize[1])_$(meshsize[2]).txt",Vx)
    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/Uy_$(meshsize[1])_$(meshsize[2]).txt",Uy)
    writedlm("../../FinalReport/DataPlots/raw_data/elastic_case2/Vy_$(meshsize[1])_$(meshsize[2]).txt",Vy)
end

###############################
# For displacement and damage #
###############################
function vtkwriter(pvd,U_a,U,D_a,D,step)

    ###############
    # Set up grid #
    ###############
    x = U.components[1].mesh.x; x = repmat(x,1,length(U.components[2].mesh.x))'
    y = U.components[2].mesh.x; y = repmat(y,1,length(U.components[1].mesh.x))

    X = zeros(U.components[1].mesh.nEl+1,U.components[2].mesh.nEl+1,1)
    Y = copy(X); Z = copy(X)
    X[:,:,1] = x
    Y[:,:,1] = y

    # Create file
    vtkfile = vtk_grid("./vtkfiles_damage/step_$step",X,Y,Z,compress=false,append=false) # no compress and append due to Zlib problem

    #################
    # Displacements #
    #################
    U_nModes = size(U_a,2)

    Ux_dof = 1:2:(U.components[1].mesh.nDofs-1)
    Vx_dof = 2:2:(U.components[1].mesh.nDofs)
    Uy_dof = (U.components[1].mesh.nDofs+1):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs-1)
    Vy_dof = (U.components[1].mesh.nDofs+2):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs)

    Ux = U_a[Ux_dof,1:nModes(U)]
    Vx = U_a[Vx_dof,1:nModes(U)]

    Uy = U_a[Uy_dof,1:nModes(U)]
    Vy = U_a[Vy_dof,1:nModes(U)]

    u = Uy*Ux'
    v = Vy*Vx'

    vtkdisp = zeros(3,U.components[1].mesh.nEl+1,U.components[2].mesh.nEl+1,1)
    vtkdisp[1,:,:,1] = u
    vtkdisp[2,:,:,1] = v
    vtk_point_data(vtkfile, vtkdisp, "displacement")


    ##########
    # Damage #
    ##########
    D_nModes = size(D_a,2)

    Dx_dof = 1:(D.components[1].mesh.nDofs)
    Dy_dof = (D.components[1].mesh.nDofs+1):(D.components[1].mesh.nDofs+D.components[2].mesh.nDofs)

    Dx = D_a[Dx_dof,1:nModes(D)]
    Dy = D_a[Dy_dof,1:nModes(D)]

    d = Dy*Dx'

    vtkdamage = zeros(D.components[1].mesh.nEl+1,D.components[2].mesh.nEl+1,1)
    vtkdamage[:,:,1] = d
    vtk_point_data(vtkfile, vtkdamage, "damage")


    # Save to collection
    collection_add_timestep(pvd,vtkfile,float(step))

    # Save to compare with FEM
    u = u.'
    v = v.'
    d = d.'

    meshsize = (size(u,1)-1, size(u,2)-1)

    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/u_PGD_$(nModes(U))modes_$(meshsize[1])_$(meshsize[2]).txt", u)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/v_PGD_$(nModes(U))modes_$(meshsize[1])_$(meshsize[2]).txt", v)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/d_PGD_$(nModes(D))modes_$(meshsize[1])_$(meshsize[2]).txt", d)

    # Save modes
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Ux_$(meshsize[1])_$(meshsize[2]).txt",Ux)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Vx_$(meshsize[1])_$(meshsize[2]).txt",Vx)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Uy_$(meshsize[1])_$(meshsize[2]).txt",Uy)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Vy_$(meshsize[1])_$(meshsize[2]).txt",Vy)

    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Dx_$(meshsize[1])_$(meshsize[2]).txt",Dx)
    writedlm("../../FinalReport/DataPlots/raw_data/damage_case1/Dy_$(meshsize[1])_$(meshsize[2]).txt",Dy)

end
