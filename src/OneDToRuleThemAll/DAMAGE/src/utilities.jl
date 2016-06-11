function build_u_function{T}(Ux::PGDComponent, u_ax::Vector{Vector{T}},
                             Uy::PGDComponent, u_ay::Vector{Vector{T}},
                             Uz::PGDComponent, u_az::Vector{Vector{T}})

    length(u_ax) == length(u_ay) == length(u_az) || throw(ArgumentError("Noob."))

    Uxdofs = 1:3:(Ux.mesh.nDofs-2)
    Vxdofs = 2:3:(Ux.mesh.nDofs-1)
    Wxdofs = 3:3:(Ux.mesh.nDofs-0)

    Uydofs = 1:3:(Uy.mesh.nDofs-2)
    Vydofs = 2:3:(Uy.mesh.nDofs-1)
    Wydofs = 3:3:(Uy.mesh.nDofs-0)

    Uzdofs = 1:3:(Uz.mesh.nDofs-2)
    Vzdofs = 2:3:(Uz.mesh.nDofs-1)
    Wzdofs = 3:3:(Uz.mesh.nDofs-0)

    lax = div(Ux.mesh.nDofs,3)
    lay = div(Uy.mesh.nDofs,3)
    laz = div(Uz.mesh.nDofs,3)

    U = zeros(lax,lay,laz)
    V = zeros(lax,lay,laz)
    W = zeros(lax,lay,laz)

    number_of_modes = length(u_ax)

    for mode in 1:number_of_modes
        Ui = vec_mul_vec_mul_vec(u_ax[mode][Uxdofs],u_ay[mode][Uydofs],u_az[mode][Uzdofs])
        U += Ui
        Vi = vec_mul_vec_mul_vec(u_ax[mode][Vxdofs],u_ay[mode][Vydofs],u_az[mode][Vzdofs])
        V += Vi
        Wi = vec_mul_vec_mul_vec(u_ax[mode][Wxdofs],u_ay[mode][Wydofs],u_az[mode][Wzdofs])
        W += Wi
    end

    return U, V, W
end
function build_d_function{T}(Dx::PGDComponent, d_ax::Vector{Vector{T}},
                             Dy::PGDComponent, d_ay::Vector{Vector{T}},
                             Dz::PGDComponent, d_az::Vector{Vector{T}})

    length(d_ax) == length(d_ay) == length(d_az) || throw(ArgumentError("Noob."))

    lax = Dx.mesh.nDofs
    lay = Dy.mesh.nDofs
    laz = Dz.mesh.nDofs

    D = zeros(lax,lay,laz)

    number_of_modes = length(d_ax)

    for mode in 1:number_of_modes
        Di = vec_mul_vec_mul_vec(d_ax[mode],d_ay[mode],d_az[mode])
        D += Di
    end

    return D
end

# function build_function{T}(Ux::PGDComponent, ax::Vector{Vector{T}},
#                           Uy::PGDComponent, ay::Vector{Vector{T}})

#     length(ax) == length(ay) || throw(ArgumentError("Noob."))

#     Uxdofs = 1:2:(Ux.mesh.nDofs-1)
#     Vxdofs = 2:2:(Ux.mesh.nDofs-0)

#     Uydofs = 1:2:(Uy.mesh.nDofs-1)
#     Vydofs = 2:2:(Uy.mesh.nDofs-0)

#     lax = div(length(ax[1]),2)
#     lay = div(length(ay[1]),2)

#     U = zeros(lax,lay,1)
#     V = zeros(lax,lay,1)

#     number_of_modes = length(ax)

#     for mode in 1:number_of_modes
#         Ui = vec_mul_vec_mul_vec(ax[mode][Uxdofs],ay[mode][Uydofs],[1.0])
#         U += Ui
#         Vi = vec_mul_vec_mul_vec(ax[mode][Vxdofs],ay[mode][Vydofs],[1.0])
#         V += Vi
#     end

#     return U, V
# end

function vec_mul_vec_mul_vec{T}(x::Vector{T},y::Vector{T},z::Vector{T})
    lx = length(x); ly = length(y); lz = length(z)

    data = T[]
    for k in 1:lz, j in 1:ly, i in 1:lx
        push!(data,x[i]*y[j]*z[k])
    end
    return reshape(data,(lx,ly,lz))
end

type IterativeFunctionComponents{Dim,T}
    U::Vector{Vector{T}}
    dims::Val{Dim}
end

function IterativeFunctionComponents{T}(x::Vector{T},y::Vector{T},z::Vector{T})
    return IterativeFunctionComponents(Vector{T}[x,y,z],Val{3}())
end

# function IterativeFunctionComponents{T}(x::Vector{T},y::Vector{T})
#     return IterativeFunctionComponents(Vector{T}[x,y],Val{2}())
# end

# function reset{T}(comps::IterativeFunctionComponents{3,T})
#     lx = length(comps.U[1])
#     ly = length(comps.U[2])
#     lz = length(comps.U[3])
#     return IterativeFunctionComponents(Vector{T}[ones(T,lx), ones(T,ly), ones(T,lz)], Val{3}())
# end

# function reset{T}(comps::IterativeFunctionComponents{2,T})
#     lx = length(comps.U[1])
#     ly = length(comps.U[2])
#     return IterativeFunctionComponents(Vector{T}[ones(T,lx), ones(T,ly)], Val{2}())
# end

function iteration_difference(compsnew::IterativeFunctionComponents{3}, compsold::IterativeFunctionComponents{3})
    xdiff = norm(compsnew.U[1] - compsold.U[1])/norm(compsold.U[1])
    ydiff = norm(compsnew.U[2] - compsold.U[2])/norm(compsold.U[2])
    zdiff = norm(compsnew.U[3] - compsold.U[3])/norm(compsold.U[3])

    return xdiff, ydiff, zdiff
end


# function iteration_difference(compsnew::IterativeFunctionComponents{2}, compsold::IterativeFunctionComponents{2})
#     xdiff = norm(compsnew.U[1] - compsold.U[1])/norm(compsold.U[1])
#     ydiff = norm(compsnew.U[2] - compsold.U[2])/norm(compsold.U[2])

#     return xdiff, ydiff
# end


function extract_eldofs{T}(a::Vector{Vector{T}}, m::Vector{Int})
    b = Vector{T}[]
    for i in 1:length(a)
        push!(b, a[i][m])
    end
    return b
end