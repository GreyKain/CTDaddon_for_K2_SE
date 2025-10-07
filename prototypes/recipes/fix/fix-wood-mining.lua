-- ##############################################################################################
-- Замена ванильной "Древесины" на "Дерево" при рубке деревьев:
-- ##############################################################################################
if settings.startup["CTD-new-tree-recipes"].value then
    local excluded_trees_list = { -- исключенные из обработки деревья
        "dead-dry-hairy-tree",
        "dead-grey-trunk",
        "dead-tree-desert",
        "dry-hairy-tree",
        "dry-tree",
        "funneltrunk",
        "hairyclubhub",
        "stingfrond",
        "boompuff",
        "cuttlepop",
        "water-cane",
        "tree-dryland-n"
    }

    -- Создаём lookup-таблицу из массива
    local excluded_trees = {}
    for _, tree_name in ipairs(excluded_trees_list) do
        excluded_trees[tree_name] = true
    end

    local new_tree = {
        {
            type = "item",
            name = "CTD-tree",
            amount = 1
        }
    }

    for _, tree in pairs(data.raw.tree) do
        if not excluded_trees[tree.name] then
            for _, tree in pairs(data.raw.tree) do
                -- Пропускаем исключённые деревья
                if not excluded_trees[tree.name] then
                    local tree_m = tree.minable
                    if tree_m then
                        if tree_m.result then
                            if tree_m.result == "wood" then
                                tree_m.mining_time = 3
                                tree_m.results = new_tree
                                tree_m.result = nil
                            else
                                tree_m.results = {
                                    {
                                        type = "item",
                                        name = tree_m.result,
                                        amount = tree_m.count or 1
                                    }
                                }
                                tree_m.result = nil
                                tree_m.count = nil
                            end
                        elseif tree_m.results then
                            for r, result in pairs(tree_m.results) do
                                if result.name == "wood" then
                                    result.name = "CTD-tree"
                                    result.amount = 1
                                end
                            end
                        else
                            tree_m.results = new_tree
                        end
                    end
                end
            end
        end
    end
end
-- ##############################################################################################