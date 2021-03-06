#########################
# For pure displacement #
#########################
function visualize(U_a,U)
    # Plots the modes

    ################
    # Displacement #
    ################
    U_nModes = size(U_a,2)

    Ux_dof = 1:2:(U.components[1].mesh.nDofs-1)
    Vx_dof = 2:2:(U.components[1].mesh.nDofs)
    Uy_dof = (U.components[1].mesh.nDofs+1):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs-1)
    Vy_dof = (U.components[1].mesh.nDofs+2):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs)

    Ux = U_a[Ux_dof,:]
    Vx = U_a[Vx_dof,:]

    Uy = U_a[Uy_dof,:]
    Vy = U_a[Vy_dof,:]


    for i = 1:U_nModes
        PyPlot.figure(1)
        PyPlot.title("Ux")
        PyPlot.plot(U.components[1].mesh.x,Ux[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(2)
        PyPlot.title("Vx")
        PyPlot.plot(U.components[1].mesh.x,Vx[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(3)
        PyPlot.title("Uy")
        PyPlot.plot(U.components[2].mesh.x,Uy[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(4)
        PyPlot.title("Vy")
        PyPlot.plot(U.components[2].mesh.x,Vy[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)
    end

end

###############################
# For displacement and damage #
##############################
function visualize(U_a,U,D_a,D)
    # Plots the modes

    ################
    # Displacement #
    ################
    U_nModes = size(U_a,2)

    Ux_dof = 1:2:(U.components[1].mesh.nDofs-1)
    Vx_dof = 2:2:(U.components[1].mesh.nDofs)
    Uy_dof = (U.components[1].mesh.nDofs+1):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs-1)
    Vy_dof = (U.components[1].mesh.nDofs+2):2:(U.components[1].mesh.nDofs+U.components[2].mesh.nDofs)

    Ux = U_a[Ux_dof,:]
    Vx = U_a[Vx_dof,:]

    Uy = U_a[Uy_dof,:]
    Vy = U_a[Vy_dof,:]


    for i = 1:U_nModes
        PyPlot.figure(1)
        PyPlot.title("Ux")
        PyPlot.plot(U.components[1].mesh.x,Ux[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(2)
        PyPlot.title("Vx")
        PyPlot.plot(U.components[1].mesh.x,Vx[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(3)
        PyPlot.title("Uy")
        PyPlot.plot(U.components[2].mesh.x,Uy[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(4)
        PyPlot.title("Vy")
        PyPlot.plot(U.components[2].mesh.x,Vy[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)
    end

    ##########
    # Damage #
    ##########
    D_nModes = size(D_a,2)

    Dx_dof = 1:(D.components[1].mesh.nDofs)
    Dy_dof = (D.components[1].mesh.nDofs+1):(D.components[1].mesh.nDofs+D.components[2].mesh.nDofs)

    Dx = D_a[Dx_dof,:]
    Dy = D_a[Dy_dof,:]

    for i = 1:D_nModes
        PyPlot.figure(5)
        PyPlot.title("Dx")
        PyPlot.plot(D.components[1].mesh.x,Dx[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)

        PyPlot.figure(6)
        PyPlot.title("Dy")
        PyPlot.plot(D.components[2].mesh.x,Dy[:,i],label="#$(i)")
        PyPlot.legend(bbox_to_anchor=(1,0),loc=4)
    end

end
