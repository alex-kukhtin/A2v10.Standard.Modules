

export interface TStore extends IArrayElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Memo: string;
	readonly IsFolder: boolean;
	Parent: TStore;
}

declare type TStoreArray = IElementArray<TStore>;

export interface TFolder extends IArrayElement {
    readonly Id: number;
    Icon: string;
    SubItems: TFolderArray;
    HasSubItems: boolean;
    Stores: TStoreArray;
    InitExpanded: boolean;
}

declare type TFolderArray = IElementArray<TFolder>;

export interface TRoot extends IRoot {
    readonly Folders: TFolderArray;
}