
const base_url = "https://galgos.inf.puc-rio.br/cvrplib/index.php/en/"
const instances_url = base_url * "instances"
const download_instance_url = base_url * "download/instance/"
const download_solution_url = base_url * "download/instanceSolution/"

# Cache for instance name to ID mapping
const instance_id_cache = Dict{String, Int}()
const cache_loaded = Ref(false)

function load_instance_cache()
    if cache_loaded[]
        return
    end

    try
        # Download the instances page
        instances_html = Downloads.download(instances_url)
        html_content = read(instances_html, String)
        rm(instances_html)

        # Parse the HTML to extract instance name to ID mappings
        # Pattern: download/instance/{id}" followed by instance name on next line
        lines = split(html_content, '\n')
        for i in 1:length(lines)-1
            line = lines[i]
            m = match(r"download/instance/(\d+)\"", line)
            if m !== nothing
                id = parse(Int, m.captures[1])
                # The instance name is on the next line, trimmed
                name_line = strip(lines[i+1])
                # Remove any HTML tags and get just the name
                name = replace(name_line, r"<[^>]*>" => "")
                name = strip(name)
                if !isempty(name)
                    instance_id_cache[name] = id
                end
            end
        end
        cache_loaded[] = true
    catch e
        @warn "Failed to load instance cache from CVRPLIB website" exception=e
    end
end

function get_instance_id(name::String)
    load_instance_cache()

    if haskey(instance_id_cache, name)
        return instance_id_cache[name]
    end

    error("No such data name exists in CVRPLIB: $name")
end

function download_cvrp(name::String)
    instance_id = get_instance_id(name)

    data_dir = joinpath(@__DIR__, "..", "data")
    vrp_file = joinpath(data_dir, name)

    if !isdir(data_dir)
        mkdir(data_dir)
    end

    # Download instance file (.vrp)
    vrp_path = vrp_file * ".vrp"
    if !isfile(vrp_path)
        try
            vrp_url = download_instance_url * string(instance_id)
            Downloads.download(vrp_url, vrp_path)
        catch e
            error("Failed to download instance file for: $name")
        end
    end

    # Download solution file (.sol)
    sol_path = vrp_file * ".sol"
    if !isfile(sol_path)
        try
            sol_url = download_solution_url * string(instance_id)
            Downloads.download(sol_url, sol_path)
        catch e
            @warn "Failed to download solution file for: $name" exception=e
        end
    end

    return [vrp_path, sol_path]
end


if abspath(PROGRAM_FILE) == @__FILE__
    download_cvrp("Li_21")
end
