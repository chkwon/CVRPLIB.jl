
const base_url = "http://vrp.atd-lab.inf.puc-rio.br/media/com_vrp/instances/"

const dir_names = [
    "A", "B", "E", "F", "M", "P", "CMT", "tai", "Golden", "Li", "X", "XXL"
]
const XXL_names = [
    "Antwerp", "Brussels", "Flanders", "Ghent", "Leuven"
]

function download_cvrp(name::String)
    dir_name = "XXL"
    for d in dir_names
        if startswith(name, d)
            dir_name = d
            break
        end
    end
    if dir_name == "XXL"
        exist = [startswith(name, xxl) for xxl in XXL_names]
        if ! any(exist) 
            error("No such data name exists in the XXL dataset of CVRPLIB: $name")
        end
    end

    data_dir = joinpath(@__DIR__, "..", "data")
    vrp_url = base_url * dir_name * "/" * name
    vrp_file = joinpath(data_dir, name)
    exts = [".vrp", ".sol"]

    if !isdir(data_dir)
        mkdir(data_dir)
    end

    for ext in exts 
        file = vrp_file * ext
        if !isfile(file)
            try
                output = Downloads.download(vrp_url * ext, file)
            catch e
                error("No such data name exists in CVRPLIB: $name")
                print(e)
            end
        end
    end
    
    return vrp_file .* exts
end


if abspath(PROGRAM_FILE) == @__FILE__
    download_cvrp("Li_21")
end
