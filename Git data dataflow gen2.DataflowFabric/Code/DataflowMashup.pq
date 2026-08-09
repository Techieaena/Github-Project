[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[BindToDefaultDestination = true]
shared gitdataAdventureWorks_Product_Categories = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "897368f4-4c45-48b3-a7ae-8bb8ee0cf8eb"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "19dc00fc-5e5c-404d-b885-f823f378130f"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "gitdataAdventureWorks_Product_Categories"]}[Content],
  Navigation = #"Navigation 4"{[Name = "AdventureWorks_Product_Categories.csv"]}[Content],
  #"Imported CSV" = Csv.Document(Navigation, [Delimiter = ",", Columns = 2, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ProductCategoryKey", Int64.Type}, {"CategoryName", type text}})
in
  #"Changed column type";
[BindToDefaultDestination = true]
shared gitdataProduct_Subcategories = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "897368f4-4c45-48b3-a7ae-8bb8ee0cf8eb"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "19dc00fc-5e5c-404d-b885-f823f378130f"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "gitdataProduct_Subcategories"]}[Content],
  Navigation = #"Navigation 4"{[Name = "AdventureWorks_Product_Subcategories.csv"]}[Content],
  #"Imported CSV" = Csv.Document(Navigation, [Delimiter = ",", Columns = 3, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"ProductSubcategoryKey", Int64.Type}, {"SubcategoryName", type text}, {"ProductCategoryKey", Int64.Type}}),
  #"Removed blank rows" = Table.SelectRows(#"Changed column type", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
  #"Removed blank rows 1" = Table.SelectRows(#"Removed blank rows", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
  #"Removed blank rows 2" = Table.SelectRows(#"Removed blank rows 1", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
  #"Removed blank rows 2";
[BindToDefaultDestination = true]
shared Mrg = let
  Source = Table.NestedJoin(gitdataProduct_Subcategories, {"ProductCategoryKey"}, gitdataAdventureWorks_Product_Categories, {"ProductCategoryKey"}, "gitdataAdventureWorks_Product_Categories", JoinKind.LeftOuter),
  #"Expanded gitdataAdventureWorks_Product_Categories" = Table.ExpandTableColumn(Source, "gitdataAdventureWorks_Product_Categories", {"CategoryName"}, {"CategoryName"})
in
  #"Expanded gitdataAdventureWorks_Product_Categories";
shared DefaultDestination = let
  Source = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "897368f4-4c45-48b3-a7ae-8bb8ee0cf8eb"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "19dc00fc-5e5c-404d-b885-f823f378130f"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "dbo", ItemKind = "Schema"]}[Data]
in
  #"Navigation 3";
