inputs = File.open("input.txt").readlines.map(&:chomp)

# test
# inputs = [
#     "COM)BBB",
#     "BBB)CCC",
#     "CCC)DDD",
#     "DDD)EEE",
#     "EEE)FFF",
#     "BBB)GGG",
#     "GGG)HHH",
#     "DDD)III",
#     "EEE)JJJ",
#     "JJJ)KKK",
#     "KKK)LLL",
#     "KKK)YOU",
#     "III)SAN"
# ]


mySun = nil
santasSun = nil

# using the following structure to represent orbits
# {
#     SUN: ['MOON1', 'MOON2'],
#     MOON2: ['MOON3']
# }

# build the direct orbits
directOrbits = {}

inputs.each do |orbit|
    sun = orbit[0,3]
    moon = orbit[4,3]

    if moon == 'YOU'
        mySun = sun
    elsif moon == 'SAN'
        santasSun = sun
    end
    
    directOrbits[sun] = [] if !directOrbits[sun]
    directOrbits[sun].push(moon)
end

# sun: string
# orbits: direct orbits structure from above
def get_indirect_orbits(sun, orbits)
    directs = orbits[sun]
    directs.reduce([]) do |indirects, direct|
        if orbits[direct]
            indirects.concat(orbits[direct]).concat(get_indirect_orbits(direct, orbits))
        else
            indirects
        end
    end
end

# build the indirect orbits
indirectOrbits = {}

directOrbits.keys.each do |sun|
    indirectOrbits[sun] = get_indirect_orbits(sun, directOrbits)
end

## PART 1

# combine indirect and direct objects
allOrbits = {}

directOrbits.keys.each do |sun|
    dir = directOrbits[sun]
    indir = indirectOrbits[sun] || []
    allOrbits[sun] = dir.dup.concat(indir)
end

allCount = allOrbits.keys.reduce(0) do |count, sun|
    count += allOrbits[sun].length
end

# puts allOrbits.to_s
puts "total orbits count: #{allCount}"

## PART 2

# build my orbit path
def find_parent(inputs, current) 
    nextParent = nil

    inputs.each do |orbit|
        sun = orbit[0,3]
        moon = orbit[4,3]
        if moon == current
            nextParent = sun
            break
        end
    end

    return nextParent
end

def find_parents(inputs, firstSun)
    parents = [firstSun]
    while !find_parent(inputs, parents.last).nil? do
        parents.push(find_parent(inputs, parents.last))
    end
    return parents
end

# build list of parents in order
myParents = find_parents(inputs, mySun)
santasParents = find_parents(inputs, santasSun)

# puts myParents.to_s
# puts santasParents.to_s

# find first common parent
firstCommonParent = nil
myParents.each do |parent|
    if santasParents.include?(parent)
        firstCommonParent = parent
        break 
    end
end

puts "number of orbital transfers: #{myParents.index(firstCommonParent) + santasParents.index(firstCommonParent)}"