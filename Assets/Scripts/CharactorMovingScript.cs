using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharactorMovingScript : MonoBehaviour {

	public float moveSpeed = 6.0f;

	private float dirX, dirY;
	
	void Update () {
		dirX = Input.GetAxis("Horizontal");
		dirY = Input.GetAxis("Vertical");
		transform.position = new Vector2(
			transform.position.x + dirX * Time.deltaTime * moveSpeed,
			transform.position.y
		);
		if (dirX != 0)
		{
			transform.localScale = new Vector3(Mathf.Sign(dirX), transform.localScale.y, transform.localScale.z);
		}
	}
}
