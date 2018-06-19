using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActingScript : MonoBehaviour {

	public float speed = 20.0f;

	void Start () {
		
	}
	
	void Update () {
		this.transform.Rotate(Vector3.up * speed * Time.deltaTime);
	}
}
