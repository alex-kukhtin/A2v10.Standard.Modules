

export interface TUnit extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Short: string;
	Memo: string;
}

export interface TItem extends IElement {
	readonly Id: number;
	readonly IsSystem: boolean;
	Name: string;
	Unit: TUnit;
	VatRate: string;
	Memo: string;
}   

export interface TRoot extends IRoot {
    readonly Item: TItem; 
}