package objects.characters;

class Enemy extends BaseCharacter
{
	public function new()
	{
		super('red');

		flipX = true;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
